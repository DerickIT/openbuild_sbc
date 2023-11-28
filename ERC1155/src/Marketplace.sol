pragma solidity ^0.8.14;
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Marketplace
 * @dev This contract inherits from ERC1155 and Ownable contracts. It implements a marketplace for ERC1155 tokens.
 */
contract Marketplace is ERC1155, Ownable {
    // Mapping to keep track of roles
    mapping(bytes32 => mapping(address => bool)) public roles;
    
    // Constants for different tiers
    uint256 public constant Tier1 = 1;
    uint256 public constant Tier2 = 2;
    uint256 public constant Tier3 = 3;
    uint256 public constant Tier4 = 4;
    uint256 public constant Tier5 = 5;
    
    // Constant for minting limit
    uint public constant mintingLimit = 20;
    
    // Constant for MINTER role
    bytes32 private constant MINTER = keccak256(abi.encode("MINTER"));

    /**
     * @dev Constructor that sets the initial price for each tier.
     * @param _apiEndPoint The API endpoint for the ERC1155 contract.
     */
    constructor(string memory _apiEndPoint) ERC1155(_apiEndPoint) {
        setInitialPrice();
    }

    /**
     * @dev Function to grant MINTER role to an address.
     * @param _add The address to grant the MINTER role.
     */
    function grantMinterRole(address _add) public onlyOwner {
        roles[MINTER][_add] = true;
    }

    // Mapping to keep track of tier to value
    mapping(uint => uint) public tiertovalue;

    /**
     * @dev Function to set the initial price for each tier.
     */
    function setInitialPrice() private {
        tiertovalue[1] = 2e18;
        tiertovalue[2] = 1e18;
        tiertovalue[3] = 75e16;
        tiertovalue[4] = 5e17;
        tiertovalue[5] = 1e17;
    }

    /**
     * @dev Function to mint tokens.
     * @param _tierNumber The tier number of the token.
     * @param _nooftokens The number of tokens to mint.
     */
    function mintToken(uint _tierNumber, uint _nooftokens) public payable {
        uint totalamount = tiertovalue[_tierNumber] * _nooftokens;
        require(
            (balanceOf(msg.sender, _tierNumber) + _nooftokens) <= mintingLimit,
            "you have reached the minting Limit"
        );
        require(roles[MINTER][msg.sender], "You are not the minter");
        require(msg.value == totalamount, "Required Amount is not paid");
        _mint(msg.sender, _tierNumber, _nooftokens, "");
    }

    /**
     * @dev Function to burn tokens.
     * @param _tierNumber The tier number of the token.
     * @param _nooftokens The number of tokens to burn.
     */
    function burnToken(uint _tierNumber, uint _nooftokens) public {
        require(roles[MINTER][msg.sender], "You are not the minter");
        require(
            balanceOf(msg.sender, _tierNumber) >= _nooftokens,
            "You do not have enough tokens"
        );
        bool success;
        bytes memory data;
        (success, data) = payable(msg.sender).call{value: 5e16 * (_nooftokens)}(
            ""
        );
        require(success, "Transfer failed.");
        _burn(msg.sender, _tierNumber, _nooftokens);
    }

    /**
     * @dev Function to update the price of tokens for each tier.
     * @param tier1price The new price for tier 1 tokens.
     * @param tier2price The new price for tier 2 tokens.
     * @param tier3price The new price for tier 3 tokens.
     * @param tier4price The new price for tier 4 tokens.
     * @param tier5price The new price for tier 5 tokens.
     */
    function updateTokenPrice(
        uint tier1price,
        uint tier2price,
        uint tier3price,
        uint tier4price,
        uint tier5price
    ) public onlyOwner {
        tiertovalue[1] = tier1price;
        tiertovalue[2] = tier2price;
        tiertovalue[3] = tier3price;
        tiertovalue[4] = tier4price;
        tiertovalue[5] = tier5price;
    }
}
