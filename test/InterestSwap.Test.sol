// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./BaseTest.sol";

import {stNEAR} from "../src/stNEAR.sol";
import {stETH} from "../src/stETH.sol";
import {USDC} from "../src/USDC.sol";

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

    IPriceFeed public priceFeedInstance;

    // more
    uint256 public initialTotalLiquidity = 10_000 * 1e18;

    address[] public addresses;

    address[] public supportedTokens;

    uint256 dailyPercent = 0.01 * 10**18;
    uint256 maxDuration = 30 * 10**18;

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
        (uint256 poolIndex, address priceModel) = interestSwapInstance
            .createPool(
                supportedTokens,
                dailyPercent,
                initialTotalLiquidity,
                maxDuration
            );

        InterestSwapPeriphery.PoolInfo memory result = interestSwapPeriphery
            .getPool(lp1, poolIndex);

        // assert specific pool
        assertEq(result.totalLiquidity, initialTotalLiquidity);
        assertEq(address(result.priceModel), address(priceModel));

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
        vm.startPrank(lp1);

        // approve first
        usdcInstance.approve(
            address(interestSwapInstance),
            initialTotalLiquidity
        );

        // create pool
        (uint256 poolIndex, ) = interestSwapInstance.createPool(
            supportedTokens,
            dailyPercent,
            initialTotalLiquidity,
            maxDuration
        );

        uint256 numberOfDays = 50 * 10**18;
        uint256 amount = 1 * 10**18; // 1 stETH
        InterestSwap.Route memory route = InterestSwap.Route(lp1, poolIndex);

        (
            uint256 assetPercentageToCharge,
            uint256 amounToBeSent,
            uint256 amounToBeSentInUSDC
        ) = interestSwapInstance.quote(
                address(stETHInstance),
                amount,
                numberOfDays,
                route
            );

        assertEq(assetPercentageToCharge, 0.5 * 10**18);
        assertEq(amounToBeSent, 0.5 * 10**18);
        assertEq(amounToBeSentInUSDC, 500 * 10**18);

        vm.stopPrank();
    }

    function testSwap() public {
        vm.startPrank(lp1);

        // approve first
        usdcInstance.approve(
            address(interestSwapInstance),
            initialTotalLiquidity
        );

        // create pool
        (uint256 poolIndex, ) = interestSwapInstance.createPool(
            supportedTokens,
            dailyPercent,
            initialTotalLiquidity,
            maxDuration
        );

        vm.stopPrank();

        vm.startPrank(borrower1);

        uint256 numberOfDays = 50 * 10**18;
        uint256 amount = 1 * 10**18; // 1 stETH
        InterestSwap.Route memory route = InterestSwap.Route(lp1, poolIndex);

        // approve first
        stETHInstance.approve(address(interestSwapInstance), amount);

        uint256 result = interestSwapInstance.swap(
            address(stETHInstance),
            amount,
            numberOfDays,
            route
        );

        assertEq(result, 500 * 10**18);
        vm.stopPrank();
    }
}
