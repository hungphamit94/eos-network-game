#!/bin/bash
set -o errexit

echo "=== start deploy data ==="

# set PATH
PATH="$PATH:/opt/eosio/bin"
endpoint_port=7055
wallet_port=7051

# change to script directory
cd "$(dirname "$0")"

echo "=== start create accounts in blockchain ==="

# download jq for json reader, we use jq here for reading the json file ( accounts.json )
mkdir -p ~/bin && curl -sSL -o ~/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && chmod +x ~/bin/jq && export PATH=$PATH:~/bin

# loop through the array in the json file, import keys and create accounts
# these pre-created accounts will be used for saving / erasing notes
# we hardcoded each account name, public and private key in the json.
# NEVER store the private key in any source code in your real life developmemnt
# This is just for demo purpose

jq -c '.[]' accounts.json | while read i; do
  name=$(jq -r '.name' <<< "$i")
  pub=$(jq -r '.publicKey' <<< "$i")

  # to simplify, we use the same key for owner and active key of each account
  #cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port create account eosio $name $pub $pub
  #YOUR_ACCOUNT_NAME
CREATOR="eosio"

#NEW_ACCOUNT_NAME
NEWACC=$name

#NEW_ACCOUNT_OWNER_PUB_KEY
KEY_OWNER_1=$pub

#NEW_ACCOUNT_ACTIVE_PUB_KEY
KEY_ACTIVE_1=$pub

#STAKE to CPU
STAKE_CPU="10.0000 EOS"

#STAKE to NET
STAKE_NET="10.0000 EOS"

#Buy RAM kbyts
BUYRAM=4096

# create account for notechainacc with above wallet's public keys
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port system newaccount --stake-net "$STAKE_NET" --stake-cpu "$STAKE_CPU" --buy-ram-kbytes $BUYRAM $CREATOR $NEWACC $KEY_OWNER_1 $KEY_ACTIVE_1 -p eosio@active

done
