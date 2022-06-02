[![Docker](https://badgen.net/badge/icon/docker?icon=docker&label)](https://hub.docker.com/r/requestnetwork/request-ipfs)

# Request IPFS

A Docker image to access Request's private IPFS swarm.

## Usage

This image is stored on [Docker Hub](https://hub.docker.com/r/requestnetwork/request-ipfs).
For a complete example, see the [docker-compose.yml](../docker-compose.yml) file.

To run the image, you can execute:

```bash
docker run -p 4001:4001 -p 5001:5001 requestnetwork/request-ipfs
```

## Versions

Image tags represent the matching version (tag) of the base [ipfs/go-ipfs](https://hub.docker.com/r/ipfs/go-ipfs/) Docker image.
