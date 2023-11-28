// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import {Script} from "../lib/forge-std/src/Script.sol";

/**
 * @title HelperConfig
 * @dev This contract is used to manage network configurations for different chains.
 */
contract HelperConfig is Script {
    error HelperConfig__ChainIdNotSupported();

    /**
     * @dev Represents the configuration for a specific network.
     */
    struct NetworkConfig {
        uint256 deployerKey;
    }

    uint256 public constant DEFAULT_ANVIL_PRIVATE_KEY =
        0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
    NetworkConfig public activeNetworkConfig;

    /**
     * @dev Sets the active network configuration based on the chain ID.
     */
    constructor() {
        if (block.chainid == 31337) {
            activeNetworkConfig = getOrCreateAnvilNetworkConfig();
        } else if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaNetworkConfig();
        } else {
            revert HelperConfig__ChainIdNotSupported();
        }
    }

    /**
     * @dev Returns the Anvil network configuration, or creates it if it doesn't exist.
     * @return _anvilNetworkConfig The Anvil network configuration.
     */
    function getOrCreateAnvilNetworkConfig() internal view returns (NetworkConfig memory _anvilNetworkConfig) {
        // Check to see if we set an active network config
        if (activeNetworkConfig.deployerKey == DEFAULT_ANVIL_PRIVATE_KEY) {
            return activeNetworkConfig;
        }

        _anvilNetworkConfig = NetworkConfig({deployerKey: DEFAULT_ANVIL_PRIVATE_KEY});
    }

    /**
     * @dev Returns the Sepolia network configuration.
     * @return _sepoliaNotworkConfig The Sepolia network configuration.
     */
    function getSepoliaNetworkConfig() internal view returns (NetworkConfig memory _sepoliaNotworkConfig) {
        _sepoliaNotworkConfig = NetworkConfig({deployerKey: vm.envUint("PRIVATE_KEY")});
    }
}
