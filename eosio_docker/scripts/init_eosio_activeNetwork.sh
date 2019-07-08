#!/usr/bin/env bash
set -o errexit

echo "=== setup blockchain active network ==="

# set env
endpoint_port=7055
wallet_port=7051

### Step 1: Configure the initial set of nodeos nodes

## EOS Account:
# Owner Permission: Change account ownership/ other high level account changes.
# Active Permission: Send A transaction/ Stake tokens/ Vote, Buy ram, etc.

# eosio key
# Private key: 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3
# Public key: EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV

# System owner key
# Private key: 5J9S4oY764EjigGHJobsGNKreBNx7ToP6C79kmokY9dHQwZKSmA
# Public key: EOS5jRVpRcqDHhuCi7iLqmamjZsFhG6s8m2DFsZnpaav91VQkoQTY
# System active key
# Private key: 5JudNYDXqB4vXV5Uxu2WwUYyieqt5gSzHtEKLvUfq6FLKx43u3H
# Public key: EOS5TatQxBtpcni5uiDkZxb8VZHZBcdRD3PxX9A8vH9m78jz6zciH

# Bpnode1 owner key
# Private key: 5K1rkMXB2YKSzWiSEaWJ1gcnHbWxXp9McGRXktABe7JC8zVe4ud
# Public key: EOS6CszdKthEgph6WB9iwtFsw9Bv8fDM4mw1d3CRo98EYAMkwjPM1
# Bpnode1 public key
# Private key: 5JpTMJwA1R9DbimPDBMw8cohqYfX6f2bcF8baktmVrvzg1x88mr
# Public key: EOS6j5SrvMT8EeP8oeHpeWHsG8SXtMzdruTnLzDC1RRFdjjJLXRv4

# Bpnode2 owner key
# Private key: 5JJ3XYzaJvsGnb2EChR7W1MZNLEugNtF7nGgXaheCGbNZ9t4vMQ
# Public key: EOS78sayWgSkrn3aX2EnjabFsnAszxkNGaHNqABqY6opbhV1G2GFE
# Bpnode2 public key
# Private key: 5HrhP5YUtdwMM8mw34rhNkyAXLmAgCGdhUavFVwGstF7FxRcD3Y
# Public key: EOS5aKjN1FD5fr6gtLVVsABb6btWkYd1jshzzKAE7EGpNobHqBzoN

# Bpnode3 owner key
# Private key: 5JB7mQ3qRm23ZzCLqEqKsERFs49sPxGvtehwsBMW2VCTP9k7PDf
# Public key: EOS65AEFAxQZ8WfWRHQ26JXjovfbyHJvKyhaoQ1nHLQ8T9Uvf8hBL
# Bpnode3 public key
# Private key: 5KN8MvbtqKStkvZ7VwRgxjYwYMNn9ySE4XL9xSBBcAwQWfjxzfc
# Public key: EOS6kYfuZcDD7geqf99B2TG5eP1JHjZ6eQGH6wSy46yiZSszHcLnY

# Account owner inita/initb/initc
# Private key: 5KJWwKAqPpQb3fSYfA68deysbXMyM5tqt98TJogSnAYXikpVsBp
# Public key: EOS6dFH1jb5S2f5CDkJZarDueYsJTqEHZVsaxBEXuay9mY5YcBTsT
# Account public inita/initb/initc
# Private key: 5Hun5YaUasJoTNCJGZp8WttfNH6rps9SWFxtjF8uDdG9LV4mm8B
# Public key: EOS8R1x3xAhRvMkRabBQeoHKnWEjyagRGSftpccDzMBTxN8v3JDbQ

# Root public key
owner_pubkey=EOS67oenWEHGTCue4j72u7yYMvA8wcKQ6rtkFiB5MJXHioEpQZLsn
active_pubkey=EOS7JeGvqYWGGtzrngd4G3W2meF5PbsBbMjBJtsBzCuv4EagZkGFn

# Root public key
sys_owner_pubkey=EOS5jRVpRcqDHhuCi7iLqmamjZsFhG6s8m2DFsZnpaav91VQkoQTY
sys_active_pubkey=EOS5TatQxBtpcni5uiDkZxb8VZHZBcdRD3PxX9A8vH9m78jz6zciH

# Bpnode1 public key
bp1_owner_pubkey=EOS6CszdKthEgph6WB9iwtFsw9Bv8fDM4mw1d3CRo98EYAMkwjPM1
bp1_active_pubkey=EOS6j5SrvMT8EeP8oeHpeWHsG8SXtMzdruTnLzDC1RRFdjjJLXRv4

# Bpnode2 public key
bp2_owner_pubkey=EOS78sayWgSkrn3aX2EnjabFsnAszxkNGaHNqABqY6opbhV1G2GFE
bp2_active_pubkey=EOS5aKjN1FD5fr6gtLVVsABb6btWkYd1jshzzKAE7EGpNobHqBzoN

# Bpnode3 public key
bp3_owner_pubkey=EOS65AEFAxQZ8WfWRHQ26JXjovfbyHJvKyhaoQ1nHLQ8T9Uvf8hBL
bp3_active_pubkey=EOS6kYfuZcDD7geqf99B2TG5eP1JHjZ6eQGH6wSy46yiZSszHcLnY

bp4_owner_pubkey=EOS6PUh9rs7eddJNzqgqDx1QrspSHLRxLMcRdwHZZRL4tpbtvia5B
bp4_active_pubkey=EOS7kdcquJBHzDjBDYSD79PADWhwc3J1UfNrUYi5iAUsaVTGUU9SW

# cleos --url=http://127.0.0.1:7055 --wallet-url=http://127.0.0.1:7051 wallet import -n eosiomain --private-key 5JtqsQQKKW5fiUdUF3VtNd5dWidKwCdh2aZrQUYSGHxFYzsVCa8

# cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port transfer eosio.token bpnode4 '100000.0000 EOS' -p eosio.token@active

# cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port create account eosio bpnode4 $bp4_owner_pubkey $bp4_active_pubkey -p eosio@active
 
# echo "=== sao lai the ta ==="

# cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port system regproducer bpnode4 $bp4_active_pubkey "http://127.0.0.1/bpnode4" -p bpnode4@active

# cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port system voteproducer prods initc "bpnode4" -p initc@active

# cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port push action eosio setprods "{ \"version\": 1, \"schedule\": [{\"producer_name\": \"bpnode4\",\"block_signing_key\": \"EOS65AEFAxQZ8WfWRHQ26JXjovfbyHJvKyhaoQ1nHLQ8T9Uvf8hBL\"}]}" -p eosio@active

# Acc public key
acc_owner_pubkey=EOS6dFH1jb5S2f5CDkJZarDueYsJTqEHZVsaxBEXuay9mY5YcBTsT
acc_active_pubkey=EOS8R1x3xAhRvMkRabBQeoHKnWEjyagRGSftpccDzMBTxN8v3JDbQ

### Step 2: Start the "genesis" node
## cleos wallet create -n eosiomain --to-console | tail -1 | sed -e 's/^"//' -e 's/"$//' > eosiomain_wallet_password.txt
## cleos wallet import -n eosiomain --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

# eosio account
# cleos wallet import -n eosiomain --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3
# system account
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port wallet import -n eosiomain --private-key 5JudNYDXqB4vXV5Uxu2WwUYyieqt5gSzHtEKLvUfq6FLKx43u3H
# bpnode1 account
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port wallet import -n eosiomain --private-key 5JpTMJwA1R9DbimPDBMw8cohqYfX6f2bcF8baktmVrvzg1x88mr
# bpnode2 account
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port wallet import -n eosiomain --private-key 5HrhP5YUtdwMM8mw34rhNkyAXLmAgCGdhUavFVwGstF7FxRcD3Y
# bpnode3 account
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port wallet import -n eosiomain --private-key 5KN8MvbtqKStkvZ7VwRgxjYwYMNn9ySE4XL9xSBBcAwQWfjxzfc

cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port wallet import -n eosiomain --private-key 5JtqsQQKKW5fiUdUF3VtNd5dWidKwCdh2aZrQUYSGHxFYzsVCa8

# inita/initb/initc account
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port wallet import -n eosiomain --private-key 5Hun5YaUasJoTNCJGZp8WttfNH6rps9SWFxtjF8uDdG9LV4mm8B

### Step 3: Create important system accounts
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port create account eosio eosio.bpay $sys_owner_pubkey $sys_active_pubkey -p eosio@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port create account eosio eosio.msig $sys_owner_pubkey $sys_active_pubkey -p eosio@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port create account eosio eosio.names $sys_owner_pubkey $sys_active_pubkey -p eosio@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port create account eosio eosio.ram $sys_owner_pubkey $sys_active_pubkey -p eosio@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port create account eosio eosio.ramfee $sys_owner_pubkey $sys_active_pubkey -p eosio@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port create account eosio eosio.saving $sys_owner_pubkey $sys_active_pubkey -p eosio@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port create account eosio eosio.stake $sys_owner_pubkey $sys_active_pubkey -p eosio@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port create account eosio eosio.token $sys_owner_pubkey $sys_active_pubkey -p eosio@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port create account eosio eosio.vpay $sys_owner_pubkey $sys_active_pubkey -p eosio@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port create account eosio eosio.system $sys_owner_pubkey $sys_active_pubkey -p eosio@active

# bpnode accounts
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port create account eosio bpnode1 $bp1_owner_pubkey $bp1_active_pubkey -p eosio@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port create account eosio bpnode2 $bp2_owner_pubkey $bp2_active_pubkey -p eosio@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port create account eosio bpnode3 $bp3_owner_pubkey $bp3_active_pubkey -p eosio@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port create account eosio bpnode4 $bp4_owner_pubkey $bp4_active_pubkey -p eosio@active

# test accounts
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port create account eosio inita $acc_owner_pubkey $acc_active_pubkey -p eosio@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port create account eosio initb $acc_owner_pubkey $acc_active_pubkey -p eosio@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port create account eosio initc $acc_owner_pubkey $acc_active_pubkey -p eosio@active


### Step 4: Install the eosio.token contract
# Deploy, create and issue SYS token to eosio.token
# cleos create account eosio eosio.token $owner_pubkey $active_pubkey
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port set contract eosio.token /contracts/eosio.token -p eosio.token@active

### Step 5: Set the eosio.msig contract
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port set contract eosio.msig /contracts/eosio.msig -p eosio.msig@active

### Step 6: Create and allocate the SYS currency
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port push action eosio.token create\
  '{"issuer":"eosio.token", "maximum_supply": "1000000000.0000 EOS"}' -p eosio.token@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port push action eosio.token issue\
  '{"to":"eosio.token", "quantity": "150700000.0000 EOS", "memo": "issue"}' -p eosio.token@active

# User-issued asset
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port push action eosio.token create\
  '{"issuer":"eosio.token", "maximum_supply": "1000000000.0000 POINT"}' -p eosio.token@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port push action eosio.token issue\
  '{"to":"eosio.token", "quantity": "10000.0000 POINT", "memo": "issue"}' -p eosio.token@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port transfer eosio.token inita '100.0000 POINT' -p eosio.token@active

# Either the eosio.bios or eosio.system contract may be deployed to the eosio
# account.  System contain everything bios has but adds additional constraints
# such as ram and cpu limits.
# eosio.* accounts  allowed only until eosio.system is deployed
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port set contract eosio /contracts/eosio.bios -p eosio@active

### Step 7: Set the eosio.system contract
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port set contract eosio /contracts/eosio.system -x 1000 -p eosio@active

### Step 8: Transition from single producer to multiple producers
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port push action eosio setpriv '["eosio.msig", 1]' -p eosio@active

### Step 9: Stake tokens and expand the network
# The following recommendation is given for the initial staking process:
# 0.1 token (literally, not 10% of the account's tokens) is staked for RAM. By default, cleos stakes 8 KB of RAM on account creation, paid by the account creator. In the initial staking, the eosio account is the account creator doing the staking. Tokens staked during the initial token staking process cannot be unstaked and made liquid until after the minimum voting requirements have been met.
# 0.45 token is staked for CPU, and 0.45 token is staked for network.
# The next available tokens up to 9 total are held as liquid tokens.
# Remaining tokens are staked 50/50 CPU and network.

# Example 1.  accountnum11 has 100 SYS. It will be staked as 0.1000 SYS on RAM; 45.4500 SYS on CPU; 45.4500 SYS on network; and 9.0000 SYS held for liquid use.
# Example 2.  accountnum33 has 5 SYS. It will be staked as 0.1000 SYS on RAM; 0.4500 SYS on CPU; 0.4500 SYS on network; and 4.0000 SYS held for liquid use.
# To make the tutorial more realistic, we distribute the 1B tokens to accounts using a Pareto distribution. The Pareto distribution models an 80-20 rule, e.g., in this case, 80% of the tokens are held by 20% of the population

# SYS (main token)
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port transfer eosio.token eosio '100000.0000 EOS' -p eosio.token@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port transfer eosio.token bpnode1 '100000.0000 EOS' -p eosio.token@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port transfer eosio.token bpnode2 '100000.0000 EOS' -p eosio.token@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port transfer eosio.token bpnode3 '100000.0000 EOS' -p eosio.token@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port transfer eosio.token bpnode4 '100000.0000 EOS' -p eosio.token@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port transfer eosio.token inita '75000000.0000 EOS' -p eosio.token@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port transfer eosio.token initb '75000000.0000 EOS' -p eosio.token@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port transfer eosio.token initc '100000.0000 EOS' -p eosio.token@active

### Step 10: Create staked accounts

# Create block producer
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port system regproducer bpnode1 $bp1_active_pubkey "http://127.0.0.1/bpnode1" -p bpnode1@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port system regproducer bpnode2 $bp2_active_pubkey "http://127.0.0.1/bpnode2" -p bpnode2@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port system regproducer bpnode3 $bp3_active_pubkey "http://127.0.0.1/bpnode3" -p bpnode3@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port system regproducer bpnode4 $bp4_active_pubkey "http://127.0.0.1/bpnode4" -p bpnode4@active


# cleos system listproducers

# Buy ram
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port system buyram inita inita "1.0000 EOS" -p inita@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port system buyram initb initb "1.0000 EOS" -p initb@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port system buyram initc initc "1.0000 EOS" -p initc@active

# Delegatebw
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port system delegatebw inita inita "37499999 EOS" "37499999 EOS" -p inita@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port system delegatebw initb initb "37499999 EOS" "37499999 EOS" -p initb@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port system delegatebw initc initc "49999 EOS" "49999 EOS" -p initc@active

# Vote producer
# Chain active: need 15% of the 1 BN SYS tokens (150 MM) have voted.
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port system voteproducer prods inita "bpnode1" -p inita@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port system voteproducer prods initb "bpnode2" -p initb@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port system voteproducer prods initc "bpnode3" -p initc@active
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port system voteproducer prods initc "bpnode4" -p initc@active


### Step 11: Select the producers
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port push action eosio setprods "{ \"version\": 1, \"schedule\": [{\"producer_name\": \"bpnode1\",\"block_signing_key\": \"EOS6j5SrvMT8EeP8oeHpeWHsG8SXtMzdruTnLzDC1RRFdjjJLXRv4\"}, {\"producer_name\": \"bpnode2\",\"block_signing_key\": \"EOS5aKjN1FD5fr6gtLVVsABb6btWkYd1jshzzKAE7EGpNobHqBzoN\"}, {\"producer_name\": \"bpnode3\",\"block_signing_key\": \"EOS6kYfuZcDD7geqf99B2TG5eP1JHjZ6eQGH6wSy46yiZSszHcLnY\"},{\"producer_name\": \"bpnode4\",\"block_signing_key\": \"EOS7kdcquJBHzDjBDYSD79PADWhwc3J1UfNrUYi5iAUsaVTGUU9SW\"}]}" -p eosio@active

### Step 12: Resign eosio
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port push action eosio updateauth '{"account": "eosio", "permission": "owner", "parent": "", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio.prods", "permission": "active"}}]}}' -p eosio@owner
cleos --url=http://127.0.0.1:$endpoint_port --wallet-url=http://127.0.0.1:$wallet_port push action eosio updateauth '{"account": "eosio", "permission": "active", "parent": "owner", "auth": {"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio.prods", "permission": "active"}}]}}' -p eosio@active

