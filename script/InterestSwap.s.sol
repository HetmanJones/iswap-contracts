// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import "../src/InterestSwapPeriphery.sol";
import "../src/InterestSwap.sol";
import "../src/stETH.sol";
import "../src/stNEAR.sol";
import "../src/USDC.sol";
import "../src/PriceModel.sol";
import "../src/FluxPriceFeed.sol";

contract InterestSwapScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        address[] memory addresses = new address[](2);
        addresses[0] = 0x93993F6915Dbf72C21799A0Dbd85471Ee5B3c372; // Swapper // deployer too
        addresses[1] = 0x546874b6fAbDdD1347CF08D35e2c8BedCe30471f; // LP

        stETH stETHInstance = new stETH(addresses);
        stNEAR stNEARInstance = new stNEAR(addresses);
        USDC usdcInstance = new USDC(addresses);

        address fluxDataFeedForNEAR = 0x0a13BC1F3C441BCB165e8925Fe3E27d18d1Cd66C;
        address fluxDataFeedForETH = 0x842AF8074Fa41583E3720821cF1435049cf93565;

        FluxPriceFeed.Config memory ethConfig = FluxPriceFeed.Config(
            address(stETHInstance),
            fluxDataFeedForETH
        );

        FluxPriceFeed.Config memory nearConfig = FluxPriceFeed.Config(
            address(stNEARInstance),
            fluxDataFeedForNEAR
        );

        FluxPriceFeed.Config[] memory configs = new FluxPriceFeed.Config[](2);
        configs[0] = ethConfig;
        configs[1] = nearConfig;
        FluxPriceFeed priceFeed = new FluxPriceFeed(configs);

        // deploy main contract
        InterestSwap instance = new InterestSwap(
            address(priceFeed),
            address(usdcInstance)
        );

        // deploy periphery
        new InterestSwapPeriphery(address(instance));

        // do infinite approval
        usdcInstance.approve(address(instance), type(uint256).max);

        vm.stopBroadcast();
        vm.broadcast();
    }
}

// terminar el price feed
