#!/bin/bash

export PATH=$PATH:/usr/local/lib/node_modules
export NODE_ENV=production

create() {
    echo "Creating subgraph..."
    echo -e "\tgraph-node: $GRAPH_NODE"
    echo -e "\tnamespace: $SUBGRAPH_NAMESPACE"
    npx graph create \
        --node "$GRAPH_NODE" \
        "$SUBGRAPH_NAMESPACE" \
        --access-token ''
}

deploy() {
    local ver=
    ver=$(version)
    echo "Deploying subgraph..."
    echo -e "\tfile: $SUBGRAPH_FILE"
    echo -e "\tgraph-node: $GRAPH_NODE"
    echo -e "\tipfs: $IPFS_HOST"
    echo -e "\tnamespace: $SUBGRAPH_NAMESPACE"
    echo -e "\tversion: $ver"
    npx graph deploy \
        --node "$GRAPH_NODE" \
        --ipfs "$IPFS_HOST" \
        "$SUBGRAPH_NAMESPACE" \
        --access-token '' \
        --version-label "$ver" \
        "$SUBGRAPH_FILE"
}

check() {
    local envs=(
        SUBGRAPH_REPO
        SUBGRAPH_BRANCH
        SUBGRAPH_FILE
        SUBGRAPH_NAMESPACE
        GRAPH_NODE
        IPFS_HOST
    )
    for env in "${envs[@]}"; do
        [[ -n ${!env} ]] || error "Empty $env ENV!"
    done
}

codegen() {
    yarn codegen "$SUBGRAPH_FILE"
}

complete() {
    echo "done"
    [[ $KEEP_ALIVE -eq 1 ]] || exit 0
    echo "Keep alive active!"
    while :; do
        sleep 1
    done
}

error() {
    echo "$@"
    exit 1
}

repo() {
    echo "Cloning $SUBGRAPH_REPO:$SUBGRAPH_BRANCH..."
    mkdir repo \
        && git clone \
            --branch "$SUBGRAPH_BRANCH" \
            "$SUBGRAPH_REPO" \
            repo \
        && cd repo \
        && yarn --no-lockfile
}

version() {
    local hash=
    local subgraph=
    hash=$(git rev-parse --short "$SUBGRAPH_BRANCH")
    subgraph=$(echo "$SUBGRAPH_REPO" | awk -F '/' '{print $(NF-1),$(NF)}' | tr ' ' '_' | awk -F '.' '{print $1}')
    echo "$subgraph-$hash"
}

# start
check

repo \
    && codegen \
    && create \
    && deploy \
    && complete
