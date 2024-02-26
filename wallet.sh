#! bin/bash

cd ~
sudo apt install jq -y
sudo apt install unzip -y
curl -sfL https://raw.githubusercontent.com/akash-network/provider/main/install.sh | bash

sudo mv ./bin/provider-services /usr/bin

# setup wallet
export AKASH_KEY_NAME=provider-wallet
export AKASH_KEYRING_BACKEND=os

provider-services keys add $AKASH_KEY_NAME
export AKASH_ACCOUNT_ADDRESS="$(provider-services keys show $AKASH_KEY_NAME -a)"

export AKASH_NET="https://github.com/akash-network/net/blob/main/sandbox"
export AKASH_CHAIN_ID="$(curl -s "$AKASH_NET/chain-id.txt")"
export AKASH_NODE=https://rpc.sandbox-01.aksh.pw:443

curl -X POST https://faucet.sandbox-01.aksh.pw/faucet -d "address=$(AKASH_ACCOUNT_ADDRESS)"

export AKASH_GAS=auto
export AKASH_GAS_ADJUSTMENT=1.25
export AKASH_GAS_PRICES=0.025uakt
export AKASH_SIGN_MODE=amino-json

echo "account balances"

provider-services query bank balances --node $AKASH_NODE $AKASH_ACCOUNT_ADDRESS