# Request Contracts

A Docker image to deploy Request Contracts to ganache. 

## Usage 

For usage, see [docker-compose](../docker.compose.yml). The image is stored on [Docker Hub](https://hub.docker.com/r/requestnetwork/request-contracts).

## Versions

The docker image tags represent the matching git commit on the [Request Network](https://github.com/RequestNetwork/requestNetwork) repository.


## Contributing

There should be a new image pushed every time there is a change in Request's smart contracts.

```bash
# the commit SHA from RequestNetwork repo
SHA=bfdc43f
docker build \
    --build-arg TAG=$SHA \
    -t requestnetwork/request-contracts:$SHA
    -t requestnetwork/request-contracts:latest .

docker push requestnetwork/request-contracts:$SHA
docker push requestnetwork/request-contracts:latest
```