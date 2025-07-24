//SPDX-License-Identifier: MIT

import {Script} from "forge-std/Script.sol";

import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

pragma solidity ^0.8.18;

//1,Deploy mocks when we are on a local anvil chain
//2.Keep track of contract addresses for price feeds across different networks
//Sepolia
//Mainnet
//Localhost

//add other config variables if needed

contract HelperConfig is Script {
    NetworkConfig public activeNetworkConfig;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_ANSWER = 2000 * 10 ** 8;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            // Sepolia
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 31337) {
            // Anvil
            activeNetworkConfig = getOrCreatAnivlEthConfig();
        } else {
            revert("Unsupported network");
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 // Sepolia ETH/USD price feed address
        });
    }

    function getOrCreatAnivlEthConfig() public returns (NetworkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig; // Return existing config if already set
        }
        //1.depoly the mocks
        //2.return the mock address
        vm.startBroadcast(); // Replace with actual mock address
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_ANSWER); // 2000 USD in 8 decimals
        vm.stopBroadcast();
        return NetworkConfig({
            priceFeed: address(mockPriceFeed) // Return the mock price feed address
        });
    }
}
