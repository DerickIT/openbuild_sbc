//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "../lib/forge-std/src/Script.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract DeployBasicNft is Script {
    function run() external returns (BasicNft) {
        vm.startBroadcast();
        // 开始广播交易。

        BasicNft basicNft = new BasicNft();
        // 创建了一个新的"BasicNft"智能合约实例。

        vm.stopBroadcast();
        // 停止广播交易。

        return basicNft;
        // 返回新创建的"BasicNft"智能合约实例。
    }
}