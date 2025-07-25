// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {FundMeScript} from "../../script/FundMeScript.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/InteractionsScript.s.sol";

contract InteractionTest is Test {
    FundMe public fundMe;
    FundMeScript public fundMeScript;

    address public USER = makeAddr("USER");

    uint256 constant SEND_VALUE = 0.01 ether; // 0.01 ETH in wei
    uint256 constant START_BALANCE = 100 ether;

    function setUp() public {
        // Deploy the FundMe contract using the script
        fundMeScript = new FundMeScript();
        fundMe = fundMeScript.run(); // Contract is deployed here so the owner is msg.sender
        vm.deal(USER, START_BALANCE); // Give USER some ETH for testing
    }

    function testUserCanFundInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        // vm.deal(USER, START_BALANCE);
        // vm.startPrank(USER);
        fundFundMe.fundFundMe(address(fundMe)); // Fund the contract
        // vm.stopPrank();
        address funder = fundMe.getFunder(0);
        // assertEq(funder, USER, "Funder should be USER's address");
    }
}
