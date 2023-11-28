// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Importing required modules
import {Script, console} from "../lib/forge-std/src/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {OBC} from "../src/OBC.sol";

// DeployOBC is a contract that inherits from the Script contract.
// It is used to deploy the OBC contract on the blockchain.
contract DeployOBC is Script {
    // Constructor function
    constructor() {}

    // The run function is used to deploy the OBC contract.
    // It first creates a new HelperConfig contract and retrieves the active network configuration.
    // It then starts broadcasting transactions from the deployer's account.
    // After that, it deploys the OBC contract and stops broadcasting transactions.
    // Finally, it logs the address of the deployed OBC contract.
    function run() external returns (OBC obc, HelperConfig helperConfig) {
        helperConfig = new HelperConfig();
        (uint256 deployerKey) = helperConfig.activeNetworkConfig();
        console.log("strating deploy on chainid: %s", block.chainid);
        vm.startBroadcast(deployerKey);
        obc = new OBC("OBC", "OB");
        vm.stopBroadcast();
        console.log("deployed OBC at: %s", address(obc));
    }
}
