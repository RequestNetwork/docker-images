# Request private IPFS swarm Docker image

This repository contains the files necessary to create a docker image
for the Request private IPFS swarm.

## Building image

To build the image you should run:

```bash
docker build . -t request-ipfs
```

## Running the image

To run the image, you can execute:
docker run -p 4001:4001 request-ipfs
