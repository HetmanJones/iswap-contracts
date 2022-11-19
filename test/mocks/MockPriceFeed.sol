// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import {IPriceFeed} from "../../src/interfaces/IPriceFeed.sol";
import "../../src/dependencies/flux/CLV2V3Interface.sol";

import "forge-std/console.sol";

contract MockPriceFeed is IPriceFeed {
    // @dev target digits
    uint256 public constant TARGET_DIGITS = 18;

    function getAssetPrice(address _asset)
        external
        view
        override
        returns (uint256)
    {
        console.log("Getting asset price", _asset);
        return 1000 * 10**TARGET_DIGITS;
    }
}
