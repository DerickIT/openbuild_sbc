//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "../lib/forge-std/src/Script.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {MoodNft} from "../src/MoodNft.sol";

contract DeployMoodNft is Script {
    function run() external returns (MoodNft) {
        string memory sadSvg = vm.readFile("./img/moodNft/sad.svg");
        string memory happySvg = vm.readFile("./img/moodNft/happy.svg");

        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(
            svgToImageUri(sadSvg),
            svgToImageUri(happySvg)
        );
        vm.stopBroadcast();

        return moodNft;
    }

    /**
     * @dev Converts an SVG string to a base64 encoded image URI.
     * The resulting URI can be used as a data URL in an <img> element, for example.
     *
     * @param svg The SVG string to be converted.
     * @return The base64 encoded image URI.
     */
    function svgToImageUri(
        string memory svg
    ) public pure returns (string memory) {
        string memory baseUrl = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );

        return string(abi.encodePacked(baseUrl, svgBase64Encoded));
    }
}
