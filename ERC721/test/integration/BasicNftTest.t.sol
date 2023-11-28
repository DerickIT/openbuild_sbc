//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "../../lib/forge-std/src/Test.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {BasicNft} from "../../src/BasicNft.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public USER = makeAddr("user");
    string public constant PUG_URI =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = new BasicNft();
    }

    /**
     * @dev Tests if the name of the NFT is correct.
     * This function compares the expected name of the NFT with the actual name.
     * It uses the keccak256 hash function to compare the two names.
     * If the hashes of the two names are equal, the test passes.
     * If not, the test fails.
     */
    function testNameIsCorrect() public view {
        string memory expectedName = "BasicNft";
        string memory actualName = basicNft.name();

        assert(
            keccak256(abi.encodePacked(expectedName)) ==
                keccak256(abi.encodePacked(actualName))
        );
    }

    /**
     * @dev Test case to check if a user can mint an NFT and have a balance.
     * The function first pranks the user, then mints an NFT with a specific URI.
     * It then asserts that the balance of the user is 1 (indicating that the NFT was successfully minted),
     * and that the URI of the minted NFT matches the URI that was used to mint it.
     */
    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG_URI);

        assert(basicNft.balanceOf(USER) == 1);
        assert(
            keccak256(abi.encodePacked(PUG_URI)) ==
                keccak256(abi.encodePacked(basicNft.tokenURI(0)))
        );
    }
}
