#!/bin/bash

# envs
# CHAIN_ID=

# vars
JWT_FILE="jwtsecret.hex"

# functions
consensus_client() {
    local chain="$1"
    local data="$2"
    local secret="$3"
    local checkpoint="$4"
    echo "Starting TEKU..."
    echo -e "\tchain:\t\t${chain}"
    echo -e "\tdata:\t\t${data}"
    echo -e "\tsecret:\t\t${secret}"
    echo -e "\tcheckpoint:\t${checkpoint}"
    teku \
    --network="$chain" \
    --ee-endpoint=http://localhost:8551 \
    --data-base-path="$data" \
    --ee-jwt-secret-file="$secret" \
    --checkpoint-sync-url="$checkpoint" \
    --metrics-enabled=true
}

error() {
    echo "$1"
    exit 1
}

execution_client() {
    local chain="$1"
    local data="$2"
    local secret="$3"
    local snap=
    snap=$(get_snap_sync "$chain")
    echo "Starting NETHERMIND..."
    echo -e "\tchain:\t\t${chain}"
    echo -e "\tdata:\t\t${data}"
    echo -e "\tsecret:\t\t${secret}"
    echo -e "\tsnap-sync:\t${snap}"
    nethermind \
        --config "$chain" \
        --datadir "$data" \
        --HealthChecks.Enabled true \
        --JsonRpc.Host "0.0.0.0" \
        --Sync.SnapSync "$snap" \
        --JsonRpc.JwtSecretFile "$secret" &
}

get_chain_name() {
    local chain_id="$1"
    case "$chain_id" in
        "0")
            echo "mainnet"
            ;;
        "11155111")
            echo "sepolia"
            ;;
        "5")
            echo "goerli"
            ;;
        "100")
            echo "gnosis"
            ;;
    esac
}

get_checkpoint_url() {
    local chain="$1"
    case "$chain" in
        "mainnet")
            echo "https://beaconstate.info/"
            ;;
        "goerli")
            echo "https://beaconstate-goerli.chainsafe.io/"
            ;;
        "sepolia")
            echo "https://beaconstate-sepolia.chainsafe.io/"
            ;;
        "gnosis")
            echo "https://checkpoint.gnosischain.com/"
            ;;
    esac
}

generate_secret() {
    local secret="$1"
    echo "Generating secret: ${secret}"
    openssl rand -hex 32 | tr -d "\n" > "$secret"
}

get_snap_sync() {
    local chain="$1"
    case "$chain" in
        "goerli"|"sepolia"|"mainnet")
            echo "true"
            ;;
        *)
            echo "false"
            ;;
    esac
}

mk_dir() {
    echo "Creating $1..."
    mkdir -p "$1"
}

main() {
    local chain="$1"
    local data="$2"
    local secret="$3"
    local checkpoint=${CHECKPOINT_URL:="$(get_checkpoint_url "$chain")"}
    [[ -n "$checkpoint" ]] || error "Null checkpoint!"
    local rpc_timeout=${RPC_TIMEOUT:=300}
    echo "RPC_TIMEOUT: $rpc_timeout"
    execution_client "$chain" "${data}/nethermind" "$secret"
    local n=0
    while ! netcat -z localhost 8545; do
        sleep 1
        ((n++))
        [[ $n -gt $RPC_TIMEOUT ]] && error "RPC Server timeout!"
    done
    consensus_client "$chain" "${data}/teku" "$secret" "$checkpoint"
}

# start

JAVA_HOME_PATH=$(find / -type d -name "jdk*" 2> /dev/null | head -n 1)

[[ -n $JAVA_HOME_PATH ]] || error "Unable to determine JAVA_HOME!"

echo "JAVA_HOME: ${JAVA_HOME_PATH}"

export JAVA_HOME=$JAVA_HOME_PATH

[[ -n $DATA_DIR ]] || error "Empty DATA_DIR ENV!"

[[ -d $DATA_DIR ]] || mk_dir "$DATA_DIR"

JWT_PATH=$DATA_DIR/$JWT_FILE

[[ -f $JWT_PATH ]] || generate_secret "$JWT_PATH"

[[ -n "$CHAIN_ID" ]] || error "Empty CHAIN_ID ENV!"

chain=$(get_chain_name "$CHAIN_ID")

[[ -n "$chain" ]] || error "Invalid CHAIN_ID: ${CHAIN_ID}!"

echo "Chain, id: ${CHAIN_ID}, name: ${chain}"

main "$chain" "$DATA_DIR" "$JWT_PATH"
