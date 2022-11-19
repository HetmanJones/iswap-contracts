// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Pool.sol";

contract PoolTest is Test {
    Pool public poolInstance;

    function setUp() public {
        // create test collateral token
        // create test stablecoin token
        poolInstance = new Pool();
    }

    function testParametersCreation() public {
        assertEq(poolInstance.acceptedTokens(0), []);
        assertEq(poolInstance.acceptedTokens(1), []);
        assertEq(poolInstance.totalLiquidity(), []);
        assertEq(poolInstance.liquidityToken(), []);
        assertEq(poolInstance.priceModel(), []);
        assertEq(poolInstance.priceFeed(), []);

        assertEq(poolInstance.isAssetSupported(), []);
        assertEq(poolInstance.isAssetSupported(), []);
    }

    function testQuote(uint256 x) public {
        uint256 price = poolInstance.quote();
        assertEq(price, x);
    }
}
