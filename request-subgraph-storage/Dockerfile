FROM debian:12-slim

# runtime-env
ENV SUBGRAPH_BRANCH_REPO=https://github.com/RequestNetwork/storage-subgraph.git
ENV SUBGRAPH_BRANCH=main
ENV SUBGRAPH_FILE=
ENV SUBGRAPH_NAMESPACE=request-network/request-storage

ENV WEB3_URL=
ENV GRAPH_NODE_URL=
ENV IPFS_URL=

ENV KEEP_ALIVE=1

# shell
SHELL ["/bin/bash", "-c"]

# build-start
WORKDIR /opt/storage-subgraph

# install build dependencies
COPY resources/apt.txt .

RUN apt-get update >/dev/null \
    && apt-get install -y --no-install-recommends `cat apt.txt | tr "\n" " "` &>/dev/null \
    && apt-get clean

# download resources
COPY resources/wget.txt .

RUN wget -i wget.txt

# install node
RUN tar xf node-*.gz \
    && cd `ls -d */ | grep node` \
    && for d in `ls -d */`; do cp -R $d /usr/local; done

# install yarn
RUN npm i -G yarn

COPY entrypoint.sh .

RUN chmod +x *.sh

# start-runtime
ENTRYPOINT [ "./entrypoint.sh" ]
