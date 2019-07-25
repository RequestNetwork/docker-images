FROM ipfs/go-ipfs:latest
WORKDIR '/data/ipfs-config'
COPY . .

ENV LIBP2P_FORCE_PNET 1

ENTRYPOINT ["/bin/sh", "/data/ipfs-config/init_ipfs"]
CMD ["daemon", "--migrate=true"]
