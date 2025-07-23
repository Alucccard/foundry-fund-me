// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundeMeTest is Test {
    FundMe fundMe;

    function setUp() public {
        fundMe = new FundMe();
    }

    function testDemo() public {
        assertEq(fundMe.MINIMUM_USD(), 0, "wrong minimum USD value");

        console.log(fundMe.MINIMUM_USD());
        console.log("This is a test for FundMe contract");
    }

    function testContractOwner() public {
        // Check if the contract owner is set correctly
        assertEq(
            fundMe.i_owner(),
            address(this),
            "Contract owner should be the deployer"
        );
    }
}
