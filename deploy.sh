#!/bin/bash

echo "About to deploy"

source .env

forge script script/InterestSwap.s.sol:InterestSwapScript --rpc-url $GOERLI_RPC_URL --private-key $PRIVATE_KEY --broadcast