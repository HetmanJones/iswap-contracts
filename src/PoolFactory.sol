// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Pool} from "./Pool.sol";
import {IPriceFeed} from "./interfaces/IPriceFeed.sol";

contract PoolFactory {
    IPriceFeed public priceFeed;

    mapping(address => Pool) public pools;

    struct TokenInfo {
        uint8 decimals;
        string name;
        string symbol;
        address tokenAddress;
    }

    struct PoolInfo {
        address priceModel;
        TokenInfo liquidityToken;
        TokenInfo[] acceptedTokens;
        uint256 totalLiquidity;
        address priceFeed;
    }

    function createPool(
        address[] memory _acceptedTokens,
        address _priceModel,
        address _liquidityTokenAddress,
        uint256 _initialLiquidity
    ) external returns (Pool) {
        Pool newPool = new Pool(
            _acceptedTokens,
            _priceModel,
            _liquidityTokenAddress,
            address(priceFeed),
            _initialLiquidity
        );
        pools[msg.sender] = newPool;
        return newPool;
    }

    // TODO: add permissioning
    function setPriceFeed(address _newPriceFeed) external {
        priceFeed = IPriceFeed(_newPriceFeed);
    }

    // getPools
    function getPoolInfo() external returns (PoolInfo[] memory) {
        // get all pools of a particular user
    }
}

// TODO
// create pool
// get pools
