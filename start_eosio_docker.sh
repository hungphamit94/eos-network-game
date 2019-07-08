#!/usr/bin/env bash
set -o errexit

# change to script's directory
cd "$(dirname "$0")/eosio_docker"

#docker network create eosdev
docker network create --driver=bridge --subnet=172.18.2.0/24 --gateway=172.18.2.10 eosdev

### Start the eosio bios Node
script="./scripts/init_blockchain.sh"
echo "=== run docker container from the eosio/eos-dev image ==="
docker run --rm --name eosio_bios -d \
  --publish 7053:7053 --publish 7054:7054 --publish 7055:7055 --publish 127.0.0.1:7051:7051 \
  --network eosdev \
  --mount type=bind,src="$(pwd)"/contracts,dst=/opt/eosio/bin/contracts \
  --mount type=bind,src="$(pwd)"/scripts,dst=/opt/eosio/bin/scripts \
  --mount type=bind,src="$(pwd)"/data,dst=/mnt/dev/data \
  -w "/opt/eosio/bin/" vicchainio/eos-dev /bin/bash -c "$script"


### Wait eosio-bios starting
sleep 20s


### Start the bpnode1 producer Node
scriptBpnode1="./scripts/init_bpnode1.sh"
echo "=== run docker container eosio_bpnode1 from the vicchainio/eosio image ==="
##  Create config and data directories for each nodeos
#    You will use these directories with the --config-dir and --data-dir parameters on the nodeos command line.
##  Prepare IP addresses for peer-to-peer communication
#   docker inspect bpnode1 | grep IPAddress
#    "IPAddress": "172.18.2.3"
#    --bnet-endpoint=0.0.0.0:16667 --http-server-address=0.0.0.0:16665 --p2p-listen-endpoint=0.0.0.0:16666 --p2p-peer-address=172.18.2.2:5556
##  Create a wallet. By default, keosd is automatically started to manage the wallet
#    keosd --http-server-address=0.0.0.0:16661
##  Start the genesis nodeos node
#    nodeos -e -p bpnode1 --private-key '[ \"EOS6j5SrvMT8EeP8oeHpeWHsG8SXtMzdruTnLzDC1RRFdjjJLXRv4\",\"5JpTMJwA1R9DbimPDBMw8cohqYfX6f2bcF8baktmVrvzg1x88mr\" ]' --plugin eosio::producer_plugin --plugin eosio::history_plugin --plugin eosio::chain_api_plugin --plugin eosio::history_plugin --plugin eosio::history_api_plugin --plugin eosio::http_plugin -d /mnt/dev/data/bpnode1 --config-dir /mnt/dev/config/bpnode1 --bnet-endpoint=0.0.0.0:6667 --http-server-address=0.0.0.0:6665 --p2p-listen-endpoint=0.0.0.0:6666 --p2p-peer-address=172.18.2.2:5556 --access-control-allow-origin=* --contracts-console --http-validate-host=false --filter-on='*'
docker run \
  --name eosio_bpnode1 -d \
  --publish 8053:8053 --publish 8054:8054 --publish 8055:8055 --publish 127.0.0.1:8051:8051 \
  --network eosdev \
  --mount type=bind,src="$(pwd)"/contracts,dst=/opt/eosio/bin/contracts \
  --mount type=bind,src="$(pwd)"/scripts,dst=/opt/eosio/bin/scripts \
  --mount type=bind,src="$(pwd)"/data,dst=/mnt/dev/data \
  --detach \
  -w "/opt/eosio/bin/" vicchainio/eos-dev /bin/bash -c \
  "keosd --http-server-address=0.0.0.0:8051 & exec nodeos -e -p bpnode1 -d /mnt/dev/data/bpnode1 \
    --config-dir /mnt/dev/config/bpnode1 \
    --http-validate-host=false \
    --private-key '[ \"EOS6j5SrvMT8EeP8oeHpeWHsG8SXtMzdruTnLzDC1RRFdjjJLXRv4\",\"5JpTMJwA1R9DbimPDBMw8cohqYfX6f2bcF8baktmVrvzg1x88mr\" ]' \
    --plugin eosio::producer_plugin \
    --plugin eosio::history_plugin \
    --plugin eosio::chain_api_plugin \
    --plugin eosio::history_plugin \
    --plugin eosio::history_api_plugin \
    --plugin eosio::http_plugin \
    --bnet-endpoint=0.0.0.0:8053 \
    --http-server-address=0.0.0.0:8055 \
    --p2p-listen-endpoint=0.0.0.0:8054 \
    --p2p-peer-address=172.18.2.1:7054 \
    --access-control-allow-origin='*' \
    --contracts-console \
    --max-transaction-time=1000 \
    --delete-all-blocks"

### Start the bpnode2 producer Node
echo "=== run docker container eosio_bpnode2 from the vicchainio/eosio image ==="
##  Create config and data directories for each nodeos
#    You will use these directories with the --config-dir and --data-dir parameters on the nodeos command line.
##  Prepare IP addresses for peer-to-peer communication
#   docker inspect bpnode2 | grep IPAddress
#    "IPAddress": "172.18.2.4"
#    --bnet-endpoint=0.0.0.0:17777 --http-server-address=0.0.0.0:17775 --p2p-listen-endpoint=0.0.0.0:17776 --p2p-peer-address=172.18.2.2:15556 --p2p-peer-address=172.18.2.3:16666
##  Create a wallet. By default, keosd is automatically started to manage the wallet
#    keosd --http-server-address=0.0.0.0:7771
##  Start the genesis nodeos node
#    nodeos -e -p bpnode2 --private-key '[ \"EOS5aKjN1FD5fr6gtLVVsABb6btWkYd1jshzzKAE7EGpNobHqBzoN\",\"5HrhP5YUtdwMM8mw34rhNkyAXLmAgCGdhUavFVwGstF7FxRcD3Y\" ]' --plugin eosio::producer_plugin --plugin eosio::history_plugin --plugin eosio::chain_api_plugin --plugin eosio::history_plugin --plugin eosio::history_api_plugin --plugin eosio::http_plugin -d /mnt/dev/data/bpnode2 --config-dir /mnt/dev/config/bpnode2 --bnet-endpoint=0.0.0.0:7777 --http-server-address=0.0.0.0:7775 --p2p-listen-endpoint=0.0.0.0:7776 --p2p-peer-address=172.18.2.2:5556 --p2p-peer-address=172.18.2.3:6666 --access-control-allow-origin=* --contracts-console --http-validate-host=false --filter-on='*'
docker run --rm --name eosio_bpnode2 -d \
  --publish 9053:9053 --publish 9054:9054 --publish 9055:9055 --publish 127.0.0.1:9051:9051 \
  --network eosdev \
  --mount type=bind,src="$(pwd)"/contracts,dst=/opt/eosio/bin/contracts \
  --mount type=bind,src="$(pwd)"/scripts,dst=/opt/eosio/bin/scripts \
  --mount type=bind,src="$(pwd)"/data,dst=/mnt/dev/data \
  --detach \
  -w "/opt/eosio/bin/" vicchainio/eos-dev /bin/bash -c \
  "keosd --http-server-address=0.0.0.0:9051 & exec nodeos -e -p bpnode2 -d /mnt/dev/data/bpnode2 \
    --config-dir /mnt/dev/config/bpnode2 \
    --http-validate-host=false \
    --private-key '[ \"EOS5aKjN1FD5fr6gtLVVsABb6btWkYd1jshzzKAE7EGpNobHqBzoN\",\"5HrhP5YUtdwMM8mw34rhNkyAXLmAgCGdhUavFVwGstF7FxRcD3Y\" ]' \
    --plugin eosio::producer_plugin \
    --plugin eosio::history_plugin \
    --plugin eosio::chain_api_plugin \
    --plugin eosio::history_api_plugin \
    --bnet-endpoint=0.0.0.0:9053 \
    --http-server-address=0.0.0.0:9055 \
    --p2p-listen-endpoint=0.0.0.0:9054 \
    --p2p-peer-address=172.18.2.1:7054 \
    --p2p-peer-address=172.18.2.2:8054 \
    --access-control-allow-origin='*' \
    --contracts-console \
    --max-transaction-time=1000 \
    --verbose-http-errors \
    --delete-all-blocks"

### Start the bpnode3 producer Node
echo "=== run docker container eosio_bpnode3 from the vicchainio/eosio image ==="
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

docker run --rm --name eosio_bpnode3 -d \
  --publish 10053:10053 --publish 10054:10054 --publish 10055:10055 --publish 127.0.0.1:10051:10051 \
  --network eosdev \
  --mount type=bind,src="$(pwd)"/contracts,dst=/opt/eosio/bin/contracts \
  --mount type=bind,src="$(pwd)"/scripts,dst=/opt/eosio/bin/scripts \
  --mount type=bind,src="$(pwd)"/data,dst=/mnt/dev/data \
  --detach \
  -w "/opt/eosio/bin/" vicchainio/eos-dev /bin/bash -c \
  "keosd --http-server-address=0.0.0.0:10051 & exec nodeos -e -p bpnode3 -d /mnt/dev/data/bpnode3 \
  --config-dir /mnt/dev/config/bpnode3 \
  --http-validate-host=false \
  --private-key '[ \"EOS6kYfuZcDD7geqf99B2TG5eP1JHjZ6eQGH6wSy46yiZSszHcLnY\",\"5KN8MvbtqKStkvZ7VwRgxjYwYMNn9ySE4XL9xSBBcAwQWfjxzfc\" ]' \
  --plugin eosio::producer_plugin \
  --plugin eosio::history_plugin \
  --plugin eosio::chain_api_plugin \
  --plugin eosio::history_api_plugin \
  --bnet-endpoint=0.0.0.0:10053 \
  --http-server-address=0.0.0.0:10055 \
  --p2p-listen-endpoint=0.0.0.0:10054 \
  --p2p-peer-address=172.18.2.1:7054 \
  --p2p-peer-address=172.18.2.2:8054 \
  --p2p-peer-address=172.18.2.3:9054 \
  --access-control-allow-origin='*' \
  --contracts-console \
  --max-transaction-time=1000 \
  --verbose-http-errors \
  --delete-all-blocks"

### --nolog
if [ "$1" != "--nolog" ]
then
  echo "=== follow eosio_bios logs ==="
   docker logs eosio_bios --follow
fi
