//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToUri;

    constructor() ERC721("BasicNft", "BNFT") {
        s_tokenCounter = 0;
    }

    /*
     * @title BasicNFT
     * @dev This contract represents a basic non-fungible token (NFT) implementation.
     * It provides basic functionality to track and transfer NFTs.
     * Note: This contract does not include any additional functionality, such as metadata or access controls.
     */
    function mintNft(string memory tokenUri) public {
        s_tokenIdToUri[s_tokenCounter] = tokenUri;
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter = s_tokenCounter + 1;
    }

    /*
     * @dev Returns the URI for a given token ID.
     * The URI is a metadata link that points to where the token's attributes are stored.
     * It is stored in the `s_tokenIdToUri` mapping with the token ID as the key.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * @param tokenId uint256 ID of the token to query
     * @return string URI of the given token ID
     */
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return s_tokenIdToUri[tokenId];
    }
}
