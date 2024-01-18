FROM debian:12-slim

# runtime-env
ENV SUBGRAPH_REPO=https://github.com/RequestNetwork/storage-subgraph.git
ENV SUBGRAPH_BRANCH=main
ENV SUBGRAPH_FILE=
ENV SUBGRAPH_NAMESPACE=request-network/request-storage

ENV WEB3_PROVIDER=
ENV GRAPH_NODE=
ENV IPFS_HOST=

ENV KEEP_ALIVE=1

# shell
SHELL ["/bin/bash", "-c"]

# build-start
WORKDIR /opt/app

# install build dependencies
COPY .resources/apt.txt .

RUN apt-get update >/dev/null \
    && apt-get install -y --no-install-recommends `cat apt.txt | tr "\n" " "` &>/dev/null \
    && apt-get clean

# download resources
COPY .resources/wget.txt .

RUN wget -i wget.txt

# install node
RUN tar xf node-*.gz \
    && cd `ls -d */ | grep node` \
    && for d in `ls -d */`; do cp -R $d /usr/local; done

# install yarn
RUN npm i -g yarn

# prepare-runtime
COPY entrypoint.sh .

RUN chmod +x *.sh

# start-runtime
ENTRYPOINT [ "./entrypoint.sh" ]
