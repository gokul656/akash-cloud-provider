export AKASH_KEY_NAME=my-wallet
export AKASH_KEYRING_BACKEND=os
export AKASH_ACCOUNT_ADDRESS="$(provider-services keys show $AKASH_KEY_NAME -a)"

# network configurations
export AKASH_NET="https://raw.githubusercontent.com/akash-network/net/main/sandbox"
export AKASH_CHAIN_ID="$(curl -s "$AKASH_NET/chain-id.txt")"
export AKASH_NODE="$(curl -s "$AKASH_NET/rpc-nodes.txt" | shuf -n 1)"

# network details
echo "node: $AKASH_NODE, chain-id: $AKASH_CHAIN_ID, keyring: $AKASH_KEYRING_BACKEND"

# account balance
provider-services query bank balances --node $AKASH_NODE $AKASH_ACCOUNT_ADDRESS
