FROM ipfs/go-ipfs:latest
WORKDIR '/data/ipfs'
COPY . .

ENV LIBP2P_FORCE_PNET 1

ENTRYPOINT ["/bin/sh", "/data/ipfs/init_ipfs"]
CMD ["daemon", "--migrate=true"]
