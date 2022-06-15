ARG IPFS_VERSION=latest

FROM alpine as certs
RUN apk update && apk add ca-certificates

FROM ipfs/go-ipfs:${IPFS_VERSION}
COPY --from=certs /etc/ssl/certs /etc/ssl/certs
WORKDIR '/data/ipfs-config'
RUN wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux32 \
    && chmod +x jq-linux32 \
    && mv jq-linux32 /bin/jq
COPY . .
ENV LIBP2P_FORCE_PNET 1
ENV SWARM_PORT 4001
ENTRYPOINT ["/bin/sh", "/data/ipfs-config/init_ipfs"]
CMD ["daemon", "--migrate=true"]
