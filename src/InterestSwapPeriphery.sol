// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IERC20} from "./interfaces/IERC20.sol";
import {InterestSwap} from "./InterestSwap.sol";

contract InterestSwapPeriphery {
    InterestSwap public interestSwap;

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
    }

    constructor(address _interestSwap) {
        interestSwap = InterestSwap(_interestSwap);
    }

    function getPools(address _lp) external view returns (PoolInfo[] memory) {
        uint256 totalPools = interestSwap.getUserTotalPools(_lp);

        PoolInfo[] memory result = new PoolInfo[](totalPools);

        for (uint256 i = 0; i < totalPools; i++) {
            result[i] = getPool(_lp, i);
        }

        return result;
    }

    function getPool(address _lp, uint256 _index)
        public
        view
        returns (PoolInfo memory)
    {
        InterestSwap.Pool memory pool = interestSwap.getPool(_lp, _index);

        return
            PoolInfo(
                address(pool.priceModel),
                getTokenInfo(address(interestSwap.liquidityToken())),
                getTokensInfo(pool.acceptedTokens),
                pool.totalLiquidity
            );
    }

    function getTokenInfo(address _tokenToCheck)
        internal
        view
        returns (TokenInfo memory)
    {
        IERC20 token = IERC20(_tokenToCheck);
        return
            TokenInfo(
                token.decimals(),
                token.name(),
                token.symbol(),
                _tokenToCheck
            );
    }

    function getTokensInfo(address[] memory _tokenToCheck)
        internal
        view
        returns (TokenInfo[] memory)
    {
        uint256 totalTokens = _tokenToCheck.length;
        TokenInfo[] memory result = new TokenInfo[](totalTokens);
        for (uint256 i = 0; i < totalTokens; i++) {
            result[i] = getTokenInfo(_tokenToCheck[i]);
        }
        return result;
    }
}
