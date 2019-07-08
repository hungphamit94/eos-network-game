#!/usr/bin/env bash
set -o errexit

echo "=== setup blockchain accounts and smart contract ==="

# set PATH
PATH="$PATH:/opt/eosio/bin:/opt/eosio/bin/scripts"
endpoint_port=7055
wallet_port=7051

set -m

echo "=== install EOSIO.CDT (Contract Development Toolkit) ==="
apt install /opt/eosio/bin/scripts/eosio.cdt-1.3.2.x86_64.deb

# start nodeos ( local node of blockchain )
# run it in a background job such that docker run could continue
keosd --http-server-address=0.0.0.0:7051 & exec nodeos -e -p eosio -d /mnt/dev/data/bios \
  --http-validate-host=false \
  --config-dir /mnt/dev/config/bios \
  --plugin eosio::producer_plugin \
  --plugin eosio::history_plugin \
  --plugin eosio::chain_api_plugin \
  --plugin eosio::history_api_plugin \
  --plugin eosio::http_plugin \
  --bnet-endpoint=0.0.0.0:7053 \
  --http-server-address=0.0.0.0:7055 \
  --p2p-listen-endpoint=0.0.0.0:7054 \
  --access-control-allow-origin=* \
  --contracts-console \
  --filter-on='*' \
  --max-transaction-time=1000 \
  --verbose-http-errors \
  --delete-all-blocks &
sleep 1s
until curl localhost:7055/v1/chain/get_info
do
  sleep 1s
done

# Sleep for 2 to allow time 4 blocks to be created so we have blocks to reference when sending transactions
sleep 2s
echo "=== setup wallet: eosiomain ==="
# First key import is for eosio system account
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port wallet create -n eosiomain --to-console | tail -1 | sed -e 's/^"//' -e 's/"$//' > eosiomain_wallet_password.txt
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port wallet import -n eosiomain --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

# eosio active network
init_eosio_activeNetwork.sh

echo "=== setup wallet: snake ==="
# key for eosio account and export the generated password to a file for unlocking wallet later
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port wallet create -n snakewal --to-console | tail -1 | sed -e 's/^"//' -e 's/"$//' > snake_wallet_password.txt
# First key import is for eosio system account
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port wallet import -n snakewal --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3
# Owner key for notechainwal wallet
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port wallet import -n snakewal --private-key 5JpWT4ehouB2FF9aCfdfnZ5AwbQbTtHBAwebRXt94FmjyhXwL4K
# Active key for notechainwal wallet
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port wallet import -n snakewal --private-key 5JD9AGTuTeD5BXZwGQ5AtwBqHK21aHmYnTetHgk1B3pjj7krT8N



sleep 10s
#YOUR_ACCOUNT_NAME
CREATOR="eosio"

#NEW_ACCOUNT_NAME
NEWACC="snakegame"

#NEW_ACCOUNT_OWNER_PUB_KEY
KEY_OWNER_1="EOS6PUh9rs7eddJNzqgqDx1QrspSHLRxLMcRdwHZZRL4tpbtvia5B"

#NEW_ACCOUNT_ACTIVE_PUB_KEY
KEY_ACTIVE_1="EOS8BCgapgYA2L4LJfCzekzeSr3rzgSTUXRXwNi8bNRoz31D14en9"

#STAKE to CPU
STAKE_CPU="1000.0000 EOS"

#STAKE to NET
STAKE_NET="1000.0000 EOS"

#Buy RAM kbyts
BUYRAM=4096

# create account for cardgameacc with above wallet's public keys
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port system newaccount --stake-net "$STAKE_NET" --stake-cpu "$STAKE_CPU" --buy-ram-kbytes $BUYRAM $CREATOR $NEWACC $KEY_OWNER_1 $KEY_ACTIVE_1 -p eosio@active

# echo "=== deploy smart contract ==="
# $1 smart contract name
# $2 account holder name of the smart contract
# $3 wallet for unlock the account
# $4 password for unlocking the wallet

deploy_contract.sh snake snakegame snakewal $(cat snake_wallet_password.txt)
# deploy_contract.sh cardgame cardgameacc cardgamewal $(cat cardgame_wallet_password.txt)

echo "=== create user accounts ==="
# script for create data into blockchain
create_accounts.sh

# * Replace the script with different form of data that you would pushed into the blockchain when you start your own project

echo "=== end of setup blockchain accounts and smart contract ==="
# create a file to indicate the blockchain has been initialized
touch "/mnt/dev/data/initialized"

# put the background nodeos job to foreground for docker run
fg %1
