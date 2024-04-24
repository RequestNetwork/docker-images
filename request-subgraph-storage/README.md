# Request Subgraph Storage

## Description
This image provides the means to create & deploy a subgraph to a graph node via a container job.

## Configuration
subgraph data
```bash
ENV SUBGRAPH_REPO=      # defaults to https://github.com/RequestNetwork/storage-subgraph.git
ENV SUBGRAPH_BRANCH=    # defaults to main
ENV SUBGRAPH_FILE=      # no default, typically subgraph-<chain>.yaml for above repo
ENV SUBGRAPH_NAME=      # defaults to request-network/request-storage
```
graph-node / ipfs
```bash
ENV GRAPH_NODE=         # no default, typically http://<graph-node-host>:8020
ENV IPFS_HOST=          # no default, typically http://<ipfs-host>:5001
```

```bash
ENV KEEP_ALIVE=         # options=0 or 1 (where 1 keeps the container alive)
```
