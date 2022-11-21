// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./dependencies/prb-math/PRBMathUD60x18.sol";

// @dev To make this contract ownable, so only the owner can update the parameters
contract PriceModel {
    using PRBMathUD60x18 for uint256;

    uint256 public dailyPercent;

    constructor(uint256 _dailyPercent) {
        dailyPercent = _dailyPercent;
    }

    function setDailyPercentage(uint256 _newValue) external {
        dailyPercent = _newValue;
    }

    // @dev from the amount requested, we charge you X % (the result)
    function quote(uint256 _amount, uint256 _numberOfDays)
        public
        view
        returns (uint256)
    {
        // dailyPercent * _numberOfDays = total interest
        return _amount.mul(dailyPercent).mul(_numberOfDays);
    }
}
