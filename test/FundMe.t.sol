// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {FundMeScript} from "../script/FundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    address USER = makeAddr("user");

    uint256 constant SEND_VALUE = 10000000000000000; // 0.01 ETH in wei

    modifier funded() {
        vm.prank(USER); // Simulate a transaction from USER
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

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
        assertEq(fundMe.getOwner(), msg.sender, "Contract owner should be the deployer");
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

    function testFundUpdatesFundedDataStructure() public funded {
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE, "Amount funded should be 0.01 ETH in wei");
    }

    function testAddsFunderToArrayOfFunders() public funded {
        address funder = fundMe.getFunder(0);
        assertEq(funder, USER, "Funder should be USER's address");
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.expectRevert("NotOwner()"); // Expect revert with NotOwner error
        fundMe.withdraw(); // USER tries to withdraw, should fail
    }

    function testWithdrawWithASingleFunder() public funded {
        //arrange
        uint256 startOwnerBalance = fundMe.getOwner().balance;
        uint256 startFundMeBalance = address(fundMe).balance;
        //action
        vm.prank(fundMe.getOwner()); // Simulate a transaction from the owner
        fundMe.withdraw();
        //assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0, "FundMe balance should be zero after withdrawal");
        assertEq(
            endingOwnerBalance,
            startOwnerBalance + startFundMeBalance,
            "Owner balance should increase by the FundMe balance after withdrawal"
        );
    }

    function testWithdrawWithMultipleFunders() public funded {
        //arange
        //build X number of funders
        uint160 numberOfFunders = 10;
        //a index to track the funders
        uint160 funderIndex = 1;

        //use a for loop to build the funders and fund the contract
        for (uint160 i = funderIndex; i < numberOfFunders; i++) {
            //hoax creates a new address and sends SEND_VALUE to it
            hoax(address(i), SEND_VALUE); // Simulate a transaction from each funder with SEND_VALUE
            //contract is funded by each funder
            fundMe.fund{value: SEND_VALUE}(); // Each funder funds the contract
        }

        //act
        uint256 startOwnerBalance = fundMe.getOwner().balance;
        uint256 startFundMeBalance = address(fundMe).balance;
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw(); // Owner withdraws funds
        vm.stopPrank();
        //assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0, "FundMe balance should be zero after withdrawal");
        assertEq(
            startOwnerBalance + startFundMeBalance,
            endingOwnerBalance,
            "Owner balance should increase by the FundMe balance after withdrawal"
        );
    }

    function testWithdrawWithMultipleFundersCheaper() public funded {
        //arange
        //build X number of funders
        uint160 numberOfFunders = 10;
        //a index to track the funders
        uint160 funderIndex = 1;

        //use a for loop to build the funders and fund the contract
        for (uint160 i = funderIndex; i < numberOfFunders; i++) {
            //hoax creates a new address and sends SEND_VALUE to it
            hoax(address(i), SEND_VALUE); // Simulate a transaction from each funder with SEND_VALUE
            //contract is funded by each funder
            fundMe.fund{value: SEND_VALUE}(); // Each funder funds the contract
        }

        //act
        uint256 startOwnerBalance = fundMe.getOwner().balance;
        uint256 startFundMeBalance = address(fundMe).balance;
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw(); // Owner withdraws funds
        vm.stopPrank();
        //assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0, "FundMe balance should be zero after withdrawal");
        assertEq(
            startOwnerBalance + startFundMeBalance,
            endingOwnerBalance,
            "Owner balance should increase by the FundMe balance after withdrawal"
        );
    }
}
