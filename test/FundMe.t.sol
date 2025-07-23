// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {FundMeScript} from "../script/FundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() public {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        FundMeScript fundMeScript = new FundMeScript();
        fundMe = fundMeScript.run(); //contract is deployed here so the owner is msg.sender
    }

    function testDemo() public {
        assertEq(fundMe.MINIMUM_USD(), 0, "wrong minimum USD value");

        console.log(fundMe.MINIMUM_USD());
        console.log("This is a test for FundMe contract");
    }

    function testContractOwner() public view {
        // Check if the contract owner is set correctly
        assertEq(fundMe.i_owner(), msg.sender, "Contract owner should be the deployer");
    }

    function testPriceFeedVersionIsAccurate() public {
        // Check if the price feed version is accurate
        uint256 version = fundMe.getVersion();
        assertEq(version, 4, "Price feed version should be equal to 4");
    }
}
