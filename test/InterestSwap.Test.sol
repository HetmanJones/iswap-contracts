// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./BaseTest.sol";

import "../src/stNEAR.sol";
import "../src/stETH.sol";
import "../src/USDC.sol";

import "../src/PriceModel.sol";
import "../src/InterestSwap.sol";
import "../src/InterestSwapPeriphery.sol";

import "./mocks/MockPriceFeed.sol";

contract PoolTest is BaseTest {
    InterestSwap public interestSwapInstance;
    InterestSwapPeriphery public interestSwapPeriphery;

    uint256 constant DECIMALS = 18;

    // instances
    stETH public stETHInstance;
    stNEAR public stNEARInstance;
    USDC public usdcInstance;

    PriceModel public priceModelInstance;
    IPriceFeed public priceFeedInstance;

    // more
    uint256 public initialTotalLiquidity = 10_000 * 1e18;

    address[] public addresses;

    address[] public supportedTokens;

    function setUp() public {
        // run to have accounts ready
        setupAccounts(vm);

        addresses.push(lp1);
        addresses.push(borrower1);

        // tokens
        stETHInstance = new stETH(addresses);
        stNEARInstance = new stNEAR(addresses);
        usdcInstance = new USDC(addresses);

        supportedTokens = [address(stETHInstance), address(stNEARInstance)];

        // price model
        priceModelInstance = new PriceModel();

        // price feed
        priceFeedInstance = new MockPriceFeed();

        // create interest swap instance
        interestSwapInstance = new InterestSwap(
            address(priceFeedInstance),
            address(usdcInstance)
        );

        // setup periphery
        interestSwapPeriphery = new InterestSwapPeriphery(
            address(interestSwapInstance)
        );
    }

    function testParametersCreation() public {
        assertEq(
            address(interestSwapInstance.priceFeed()),
            address(priceFeedInstance)
        );
        assertEq(
            address(interestSwapInstance.liquidityToken()),
            address(usdcInstance)
        );
    }

    function testCreatePool() public {
        // create pool as LP1
        vm.startPrank(lp1);

        // approve first
        usdcInstance.approve(
            address(interestSwapInstance),
            initialTotalLiquidity
        );

        // create pool
        uint256 poolIndex = interestSwapInstance.createPool(
            supportedTokens,
            address(priceModelInstance),
            initialTotalLiquidity
        );

        InterestSwapPeriphery.PoolInfo memory result = interestSwapPeriphery
            .getPool(lp1, poolIndex);

        // assert specific pool
        assertEq(result.totalLiquidity, initialTotalLiquidity);
        assertEq(address(result.priceModel), address(priceModelInstance));

        assertEq(result.acceptedTokens.length, 2);

        assertEq(result.acceptedTokens[0].symbol, "stETH");
        assertEq(result.acceptedTokens[0].decimals, DECIMALS);
        assertEq(result.acceptedTokens[0].name, "stETH");
        assertEq(result.acceptedTokens[0].tokenAddress, address(stETHInstance));

        assertEq(result.acceptedTokens[1].symbol, "stNEAR");
        assertEq(result.acceptedTokens[1].decimals, DECIMALS);
        assertEq(result.acceptedTokens[1].name, "stNEAR");
        assertEq(
            result.acceptedTokens[1].tokenAddress,
            address(stNEARInstance)
        );

        // assert metadata
        assertEq(result.liquidityToken.symbol, "USDC");
        assertEq(result.liquidityToken.decimals, DECIMALS);
        assertEq(result.liquidityToken.name, "USDC");
        assertEq(result.liquidityToken.tokenAddress, address(usdcInstance));

        vm.stopPrank();
    }

    function testQuote() public {
        // uint256 price = poolInstance.quote();
        // assertEq(price, x);
    }

    function testSwap() public {}
}