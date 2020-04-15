FROM ipfs/go-ipfs:v0.4.23 as jq
WORKDIR /bin
RUN wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux32
RUN chmod +x jq-linux32
RUN mv jq-linux32 jq

FROM ipfs/go-ipfs:v0.4.23
WORKDIR '/data/ipfs-config'
COPY --from=jq /bin/jq /bin/jq
COPY . .

ENV LIBP2P_FORCE_PNET 1
ENV SWARM_PORT 4001

ENTRYPOINT ["/bin/sh", "/data/ipfs-config/init_ipfs"]
CMD ["daemon", "--migrate=true"]
