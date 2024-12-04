FROM docker.io/debian:bookworm-slim as builder
RUN apt-get update && apt-get install -y gcc make wget unzip
WORKDIR /tmp
RUN wget https://codeload.github.com/pcherenkov/udpxy/zip/refs/heads/master -O udpxy-master.zip \
    && unzip udpxy-master.zip \
    && cp -r udpxy-master/chipmunk /src 
WORKDIR /src
RUN make
FROM docker.io/debian:bookworm-slim
LABEL name="udpxy" maintainer="Aurelio"
RUN mkdir -p /etc/mcproxy
COPY --from=builder /src/udpxy /usr/local/bin/udpxy
ENTRYPOINT ["/usr/local/bin/udpxy"]
CMD ["-T", "-v", "-p", "4022", "-c", "25"]
