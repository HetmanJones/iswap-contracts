// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./dependencies/solmate/ERC20.sol";

contract stETH is ERC20 {
    constructor(address[] memory _holders) ERC20("stETH", "stETH", 18) {
        uint256 holdersLength = _holders.length;

        for (uint256 i = 0; i < holdersLength; i++) {
            _mint(_holders[i], 100_000 * 1e18);
        }
    }
}
