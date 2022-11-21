// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./BaseTest.sol";

import "../src/PriceModel.sol";

contract PriceModelTest is BaseTest {
    PriceModel public priceModelInstance;

    uint256 constant DECIMALS = 18;
    // 10% / 365 = 0.02 % => 0.0002 = 0.02 %
    uint256 public dailyFeePercentage = 0.0002 * 10**18;

    function setUp() public {
        // run to have accounts ready
        setupAccounts(vm);

        // price model
        priceModelInstance = new PriceModel(dailyFeePercentage);
    }

    function testParametersCreation() public {
        assertEq(priceModelInstance.dailyPercent(), dailyFeePercentage);
    }

    function testQuote() public {
        vm.startPrank(lp1);

        uint256 numberOfDays = 50 * 10**18;
        uint256 result = priceModelInstance.quote(10000 * 10**18, numberOfDays);

        assertEq(result, 100 * 10**18);

        vm.stopPrank();
    }
}
