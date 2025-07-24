// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "../script/HelperConfig.s.sol";

contract FundMeScript is Script {
    function run() public returns (FundMe) {
        //return FundMe so we can use it in tests
        // Deploy the FundMe contract
        HelperConfig helperConfig = new HelperConfig();
        vm.startBroadcast();
        FundMe fundMe = new FundMe(helperConfig.activeNetworkConfig());
        vm.stopBroadcast();
        return fundMe;
    }
}
