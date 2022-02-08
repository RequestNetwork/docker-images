[![Docker](https://badgen.net/badge/icon/docker?icon=docker&label)](https://hub.docker.com/r/requestnetwork/request-subgraph-storage)

# Request Subgraph: Storage

A Docker image to deploy Request's storage subgraph to a TheGraph node. 

## Usage 

For usage, see [docker-compose](../docker.compose.yml). The image is stored on [Docker Hub](https://hub.docker.com/r/requestnetwork/request-subgraph-storage).

## Versions

The docker image tags represent the matching git commit on the [Request Storage Subgraph](https://github.com/RequestNetwork/storage-subgraph) repository.


## Contributing

There should be a new image pushed every time there is a change in Request's storage subgraph.

```bash
# the commit SHA from storage-subgraph repo
SHA=6a3b315
docker build \
    --build-arg TAG=$SHA \
    -t requestnetwork/request-subgraph-storage:$SHA
    -t requestnetwork/request-subgraph-storage:latest .

docker push requestnetwork/request-subgraph-storage:$SHA
docker push requestnetwork/request-subgraph-storage:latest
```
