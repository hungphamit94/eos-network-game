#!/usr/bin/env bash
set -o errexit

echo "=== setup and start block producer 4 ==="

# PATH="$PATH:/opt/eosio/bin:/opt/eosio/bin/scripts"
# endpoint_port=7055
# wallet_port=7051

# start nodeos ( local node of blockchain )
# run it in a background job such that docker run could continue
# keosd --http-server-address=0.0.0.0:7051 & exec nodeos -e -p eosio -d /mnt/dev/data/bios \
#   --http-validate-host=false \
#   --config-dir /mnt/dev/config/bios \
#   --plugin eosio::producer_plugin \
#   --plugin eosio::history_plugin \
#   --plugin eosio::chain_api_plugin \
#   --plugin eosio::history_api_plugin \
#   --plugin eosio::http_plugin \
#   --bnet-endpoint=0.0.0.0:7053 \
#   --http-server-address=0.0.0.0:7055 \
#   --p2p-listen-endpoint=0.0.0.0:7054 \
#   --access-control-allow-origin=* \
#   --contracts-console \
#   --filter-on='*' \
#   --max-transaction-time=1000 \
#   --verbose-http-errors \
#   --delete-all-blocks &
# sleep 1s
# until curl localhost:7055/v1/chain/get_info
# do
#   sleep 1s
# done

# bp4_owner_pubkey=EOS6PUh9rs7eddJNzqgqDx1QrspSHLRxLMcRdwHZZRL4tpbtvia5B
# bp4_active_pubkey=EOS7kdcquJBHzDjBDYSD79PADWhwc3J1UfNrUYi5iAUsaVTGUU9SW

# cleos --url=http://127.0.0.1:7055 --wallet-url=http://127.0.0.1:7051 wallet import -n eosiomain --private-key 5JtqsQQKKW5fiUdUF3VtNd5dWidKwCdh2aZrQUYSGHxFYzsVCa8

# echo "=== go to here together ==="

# # cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port transfer eosio.token bpnode4 '100000.0000 EOS' -p eosio.token@active

# cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port create account eosio bpnode4 $bp4_owner_pubkey $bp4_active_pubkey -p eosio@active
 
# echo "=== sao lai the ta ==="

# cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port system regproducer bpnode4 $bp4_active_pubkey "http://127.0.0.1/bpnode4" -p bpnode4@active

# cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port system voteproducer prods initc "bpnode4" -p initc@active

# cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port push action eosio setprods "{ \"version\": 1, \"schedule\": [{\"producer_name\": \"bpnode4\",\"block_signing_key\": \"EOS65AEFAxQZ8WfWRHQ26JXjovfbyHJvKyhaoQ1nHLQ8T9Uvf8hBL\"}]}" -p eosio@active

# echo "=== run docker container eosio_bpnode4 from the vicchainio/eosio image ==="
##  Create config and data directories for each nodeos
#    You will use these directories with the --config-dir and --data-dir parameters on the nodeos command line.
##  Prepare IP addresses for peer-to-peer communication
#   docker inspect bpnode3 | grep IPAddress
#    "IPAddress": "172.18.2.5"
#    --bnet-endpoint=0.0.0.0:18887 --http-server-address=0.0.0.0:18885 --p2p-listen-endpoint=0.0.0.0:18886 --p2p-peer-address=172.18.2.2:15556 --p2p-peer-address=172.18.2.3:16666 --p2p-peer-address=172.18.2.4:17776
##  Create a wallet. By default, keosd is automatically started to manage the wallet
#    keosd --http-server-address=0.0.0.0:8881
##  Start the genesis nodeos node
#    nodeos -e -p bpnode3 --private-key '[ \"EOS6kYfuZcDD7geqf99B2TG5eP1JHjZ6eQGH6wSy46yiZSszHcLnY\",\"5KN8MvbtqKStkvZ7VwRgxjYwYMNn9ySE4XL9xSBBcAwQWfjxzfc\" ]' --plugin eosio::producer_plugin --plugin eosio::history_plugin --plugin eosio::chain_api_plugin --plugin eosio::history_plugin --plugin eosio::history_api_plugin --plugin eosio::http_plugin -d /mnt/dev/data/bpnode3 --config-dir /mnt/dev/config/bpnode3 --bnet-endpoint=0.0.0.0:8887 --http-server-address=0.0.0.0:8885 --p2p-listen-endpoint=0.0.0.0:8886 --p2p-peer-address=172.18.2.2:5556 --p2p-peer-address=172.18.2.3:6666 --p2p-peer-address=172.18.2.4:7776 --access-control-allow-origin=* --contracts-console --http-validate-host=false --filter-on='*'

docker run --rm --name eosio_bpnode4 -d \
  --publish 11053:11053 --publish 11054:11054 --publish 11055:11055 --publish 127.0.0.1:11051:11051 \
  --network eosdev \
  --mount type=bind,src="$(pwd)"/contracts,dst=/opt/eosio/bin/contracts \
  --mount type=bind,src="$(pwd)"/scripts,dst=/opt/eosio/bin/scripts \
  --mount type=bind,src="$(pwd)"/data,dst=/mnt/dev/data \
  --detach \
  -w "/opt/eosio/bin/" vicchainio/eos-dev /bin/bash -c \
  "keosd --http-server-address=0.0.0.0:11051 & exec nodeos -e -p bpnode4 -d /mnt/dev/data/bpnode4 \
  --config-dir /mnt/dev/config/bpnode4 \
  --http-validate-host=false \
  --private-key '[ \"EOS7kdcquJBHzDjBDYSD79PADWhwc3J1UfNrUYi5iAUsaVTGUU9SW\",\"5JtqsQQKKW5fiUdUF3VtNd5dWidKwCdh2aZrQUYSGHxFYzsVCa8\" ]' \
  --plugin eosio::producer_plugin \
  --plugin eosio::history_plugin \
  --plugin eosio::chain_api_plugin \
  --plugin eosio::history_api_plugin \
  --bnet-endpoint=0.0.0.0:11053 \
  --http-server-address=0.0.0.0:11055 \
  --p2p-listen-endpoint=0.0.0.0:11054 \
  --p2p-peer-address=172.18.2.1:7054 \
  --p2p-peer-address=172.18.2.2:8054 \
  --p2p-peer-address=172.18.2.3:9054 \
  --p2p-peer-address=172.18.2.4:10054 \
  --access-control-allow-origin='*' \
  --contracts-console --filter-on='*' \
  --max-transaction-time=1000 \
  --verbose-http-errors \
  --delete-all-blocks"


# set -o errexit





