ARG IPFS_VERSION=latest

FROM alpine as build
RUN apk update && apk add ca-certificates && update-ca-certificates
RUN wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux32 -O /etc/jq-linux32

FROM ipfs/go-ipfs:${IPFS_VERSION}
WORKDIR '/data/ipfs-config'
COPY --from=build /etc/jq-linux32 /etc/jq-linux32
RUN chmod +x /etc/jq-linux32 \
    && mv /etc/jq-linux32 /bin/jq
COPY . .
ENV LIBP2P_FORCE_PNET 1
ENV SWARM_PORT 4001
ENTRYPOINT ["/bin/sh", "/data/ipfs-config/init_ipfs"]
CMD ["daemon", "--migrate=true"]
