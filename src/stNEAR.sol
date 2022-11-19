// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "solmate/tokens/ERC20.sol";

contract stNEAR is ERC20 {
    constructor(address[] memory _holders) ERC20("stNEAR", "stNEAR", 18) {
        uint256 holdersLength = _holders.length;

        for (uint256 i = 0; i < holdersLength; i++) {
            _mint(_holders[i], 100_000 * 1e18);
        }
    }
}
