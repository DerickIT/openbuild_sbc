pragma solidity ^0.8.14;
import {Test} from "forge-std/Test.sol";
import {Marketplace} from "../src/Marketplace.sol";

/**
 * @title MarketplaceTest
 * @dev This contract is used for testing the Marketplace contract.
 */
contract MarketplaceTest is Test {
    bytes32 private constant MINTER = keccak256(abi.encode("MINTER")); // MINTER role identifier
    Marketplace instance; // Instance of the Marketplace contract

    /**
     * @dev Sets up the test by creating a new instance of the Marketplace contract.
     */
    function setUp() public {
        instance = new Marketplace("");
    }

    /**
     * @dev Tests the grantMinterRole function of the Marketplace contract.
     */
    function testgrant() public {
        address randomuser = vm.addr(2);
        instance.grantMinterRole(randomuser);
        assert(instance.roles(MINTER, randomuser) == true);
    }

    /**
     * @dev Tests the revert functionality of the grantMinterRole function.
     */
    function testRevert() public {
        vm.expectRevert();
        address randomuser = vm.addr(2);
        vm.prank(randomuser);
        instance.grantMinterRole(randomuser);
    }

    /**
     * @dev Tests the updateTokenPrice function of the Marketplace contract.
     */
    function testupdatePrice() public {
        instance.updateTokenPrice(1e18, 2e18, 3e18, 15e17, 275e16);
    }

    /**
     * @dev Tests the revert functionality of the updateTokenPrice function.
     */
    function testupdateRevert() public {
        vm.expectRevert();
        address randomuser = vm.addr(3);
        vm.prank(randomuser);
        instance.updateTokenPrice(1e18, 2e18, 3e18, 15e17, 275e16);
    }

    /**
     * @dev Tests the mintToken function of the Marketplace contract.
     */
    function testMint() public {
        address randomuser = vm.addr(3);
        vm.deal(randomuser, 4e18);
        instance.grantMinterRole(randomuser);
        vm.prank(randomuser);
        instance.mintToken{value: 4 ether}(1, 2);
        assert(instance.balanceOf(randomuser, 1) == 2);
    }

    /**
     * @dev Tests the revert functionality of the mintToken function when the value is insufficient.
     */
    function testRevertMintval() public {
        address randomuser = vm.addr(3);
        vm.deal(randomuser, 4 ether);
        instance.grantMinterRole(randomuser);
        vm.prank(randomuser);
        instance.mintToken{value: 1 ether}(1, 2);
        assert(instance.balanceOf(randomuser, 1) == 0);
    }

    /**
     * @dev Tests the revert functionality of the mintToken function when the user is not a minter.
     */
    function testRevertnotMint() public {
        address randomuser = vm.addr(3);
        vm.deal(randomuser, 4 ether);
        vm.prank(randomuser);
        instance.mintToken{value: 1 ether}(1, 2);
    }

    /**
     * @dev Tests the revert functionality of the mintToken function when the mint limit is reached.
     */
    function testRevertMintlimit() public {
        // vm.expectRevert();
        address randomuser = vm.addr(3);
        vm.deal(randomuser, 3 ether);
        instance.grantMinterRole(randomuser);
        vm.prank(randomuser);
        instance.mintToken{value: 2 ether}(1, 1);
        vm.deal(randomuser, 42 ether);
        instance.mintToken{value: 2 ether}(1, 21);
        assert(instance.balanceOf(randomuser, 1) == 1);
    }

    /**
     * @dev Tests the burnToken function of the Marketplace contract.
     */
    function testBurn() public {
        address randomuser = vm.addr(3);
        vm.deal(randomuser, 20 ether);
        instance.grantMinterRole(randomuser);
        vm.prank(randomuser);
        instance.mintToken{value: 20 ether}(1, 10);
        vm.prank(randomuser);
        instance.burnToken(1, 3);
        assert(instance.balanceOf(randomuser, 1) == 7);
    }

    /**
     * @dev Tests the revert functionality of the burnToken function when the user does not have enough tokens.
     */
    function testBurnRevert() public {
        address randomuser = vm.addr(3);
        vm.deal(randomuser, 3 ether);
        instance.grantMinterRole(randomuser);
        vm.prank(randomuser);
        instance.mintToken{value: 2 ether}(1, 1);
        vm.prank(randomuser);
        instance.burnToken(1, 3);
    }

    /**
     * @dev Tests the revert functionality of the burnToken function when the user is not a minter.
     */
    function testBurnRevertnotminter() public {
        address randomuser = vm.addr(3);
        vm.deal(randomuser, 3 ether);
        vm.prank(randomuser);
        instance.burnToken(1, 3);
    }
}
