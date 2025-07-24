// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {FundMeScript} from "../script/FundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");

    uint256 constant SEND_VALUE = 10000000000000000; // 0.01 ETH in wei

    function setUp() public {
        // fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        FundMeScript fundMeScript = new FundMeScript();
        fundMe = fundMeScript.run(); //contract is deployed here so the owner is msg.sender
        vm.deal(USER, SEND_VALUE * 1e5); // Give USER some ETH for testin
    }

    function testDemo() public {
        assertEq(fundMe.MINIMUM_USD(), 5000000000000000000, "wrong minimum USD value");

        console.log(fundMe.MINIMUM_USD());
        console.log("This is a test for FundMe contract");
    }

    function testContractOwner() public view {
        // Check if the contract owner is set correctly
        assertEq(fundMe.i_owner(), msg.sender, "Contract owner should be the deployer");
    }

    function testPriceFeedVersionIsAccurate() public view {
        // Check if the price feed version is accurate
        uint256 version = fundMe.getVersion();
        assertEq(version, 4, "Price feed version should be equal to 4");
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert(); // Expect revert if not enough ETH is sent
        fundMe.fund{value: 0}(); // This will fail because no ETH is sent
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER); // Simulate a transaction from USER
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE, "Amount funded should be 0.01 ETH in wei");
    }
}
