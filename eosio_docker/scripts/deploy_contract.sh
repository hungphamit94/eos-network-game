#!/usr/bin/env bash
set -o errexit

# set PATH
PATH="$PATH:/opt/eosio/bin"
endpoint_port=7055
wallet_port=7051

CONTRACTSPATH="$( pwd -P )/contracts"

# make new directory for compiled contract files
mkdir -p ./compiled_contracts
mkdir -p ./compiled_contracts/$1

COMPILEDCONTRACTSPATH="$( pwd -P )/compiled_contracts"

# unlock the wallet, ignore error if already unlocked
if [ ! -z $3 ]; then cleos wallet unlock -n $3 --password $4 || true; fi

# compile smart contract to wasm and abi files using EOSIO.CDT (Contract Development Toolkit)
# https://github.com/EOSIO/eosio.cdt
(
#  eosio-cpp -abigen "$CONTRACTSPATH/$1/$1.cpp" -o "$COMPILEDCONTRACTSPATH/$1/$1.wasm" --contract "$1"
  eosiocpp -o "$COMPILEDCONTRACTSPATH/$1/$1.wast" "$CONTRACTSPATH/$1/$1.cpp" &&
  eosiocpp -g "$COMPILEDCONTRACTSPATH/$1/$1.abi" "$CONTRACTSPATH/$1/$1.cpp"
) &&

# set (deploy) compiled contract to blockchain
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port set contract $2 "$COMPILEDCONTRACTSPATH/$1/" --permission $2
