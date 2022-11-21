#!/bin/bash

echo "About to deploy to Goerli" 

# source .env.goerli

# forge script script/InterestSwap.s.sol:InterestSwapScript --rpc-url $JSON_RPC_URL --private-key $PRIVATE_KEY --chain-id 1313161555 --gas-price 120000000000

npx hardhat deploy --network "aurora-testnet"