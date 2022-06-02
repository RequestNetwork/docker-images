[![Docker](https://badgen.net/badge/icon/docker?icon=docker&label)](https://hub.docker.com/r/requestnetwork/request-node)

# Request Node

A Docker image to run a full Request Node.
Please refer to its [documentation](https://github.com/RequestNetwork/requestNetwork/tree/master/packages/request-node) for more details.

## Usage

This image is stored on [Docker Hub](https://hub.docker.com/r/requestnetwork/request-node).
For a complete example, see the [docker-compose.yml](../docker-compose.yml) file.

To run the Docker image, you can execute:

```bash
docker run -p 3000:3000 --env MNEMONIC=<your mnemonic> requestnetwork/request-node
```

You may also want to set up the following environment variables:

- `WEB3_PROVIDER_URL`
- `IPFS_HOST`
- `INITIALIZATION_STORAGE_FILE_PATH`

You can find a list of all available environment variables [here](https://github.com/RequestNetwork/requestNetwork/tree/master/packages/request-node#launch).

## Versions

Image tags represent the matching version of NPM's [@requestnetwork/request-node](https://www.npmjs.com/package/@requestnetwork/request-node) package.

- `latest` targets the latest released version of the package on NPM ;
- `next` points to the latest development version of the NPM package: `x.y.z-next.id`.
