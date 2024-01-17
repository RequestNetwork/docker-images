#!/bin/bash

export NODE_ENV="production"

error() {
    echo "$@"
    exit 1
}

version() {
    local hash=
    local subgraph=
    hash=$(git rev-parse --short "$SUBGRAPH_BRANCH")
    subgraph=$(echo "$SUBGRAPH_FILE" | tr -d './' | awk -F '.' '{print $(NF-1)}')
    echo "$subgraph-$hash"
}

repo() {
    local repo=$SUBGRAPH_REPO
    local branch=$SUBGRAPH_BRANCH
    echo "Github, repo: $repo, branch: $branch"
    local dir=
    dir=$(echo "$repo" | awk -F '/' '{PRINT $NF}')
    git clone "$repo" \
        && cd "$dir" \
        && git checkout "$branch" \
        && yarn
}

create() {
    local graph_node=$GRAPH_NODE_URL
    local namespace=$SUBGRAPH_NAMESPACE
    echo "Creating subgraph..."
    echo -e "\tgraph-node: $graph_node"
    echo -e "\tnamespace: $namespace"
    npx graph create \
        --node "$graph_node" \
        "$namespace" \
        --access-token ''
}

deploy() {
    local graph_node=$GRAPH_NODE_URL
    local ipfs=$IPFS_URL
    local namespace=$SUBGRAPH_NAMESPACE
    local v=
    v=$(version)
    echo "Deploying subgraph..."
    echo -e "\tgraph-node: $graph_node"
    echo -e "\tipfs: $ipfs"
    echo -e "\tnamespace: $namespace"
    echo -e "\tversion: $v"
    npx graph deploy \
        --node "$graph_node" \
        --ipfs "$ipfs" \
        "$namespace" \
        --access-token '' \
        --version-label "$v"
}

complete() {
    [[ -n $KEEP_ALIVE ]] || exit 0
    echo "Keep alive active!"
    while :; do
        sleep 1
    done
}

check() {
    local envs=(
        SUBGRAPH_REPO
        SUBGRAPH_BRANCH
        SUBGRAPH_FILE
        SUBGRAPH_NAMESPACE
        GRAPH_NODE_URL
        IPFS_URL
    )
    for env in "${envs[@]}"; do
        echo "$env"
        [[ -n ${!env} ]] || error "Empty $env ENV!"
    done
}

# start

check \
    && repo \
    && create \
    && deploy \
    && complete
