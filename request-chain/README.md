# Request Chain

## Description

This image provides the means to deploy an ethereum node with both execution client [Nethermind](https://www.nethermind.io/nethermind-client) & consensus client [Teku](https://consensys.io/teku).

This node is is meant to be used as a way to bootstrap a graph-node (with subgraph). This process requires a great many RPC calls, which typically leads to a high number of rate limited connections, making the sync process very slow, time consuming and potentally expensive.

## Configuration
```bash
# (required)
CHAIN_ID= # currently supported chains
#               0 - mainnet
#        11155111 - sepolia
#               5 - goerli
#             100 - gnosis

# (optional)
CHECKPOINT_URL= # consensus client beacon checkpoint
RPC_TIMEOUT=    # execution client RPC start up timeout
```

## Sync process
This is a 3 step process: -

1. block headers
2. block bodies
3. transaction receipts

The use of [checkpoints](https://eth-clients.github.io/checkpoint-sync-endpoints/) greatly increases the speed of the sync process and the checkpoint url is automatic based on the chain, but can be specified (see above).
