// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ERC20} from "solmate/tokens/ERC20.sol";

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "forge-std/console.sol";

abstract contract BaseTest is Test {
    address immutable SENDER = 0x00a329c0648769A73afAc7F9381E08FB43dBEA72;

    // Accounts
    uint256 internal lp1_pk;

    uint256 internal borrower1_pk;

    address internal lp1;

    address internal borrower1;

    constructor() {
        lp1_pk = 0x10;

        borrower1_pk = 0x11;
    }

    function setupAccounts(Vm _vm) internal {
        lp1 = _vm.addr(lp1_pk);

        borrower1 = _vm.addr(borrower1_pk);
    }
}
