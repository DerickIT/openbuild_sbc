// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "../lib/forge-std/src/Test.sol";
import "../src/OBC.sol";

contract OBCTest is DSTest {
    OBC obc;

    function setUp() public {
        obc = new OBC("OBC Token", "OBC");
    }

    function testConstructor() public {
        assertEq(obc.name(), "OBC Token");
        assertEq(obc.symbol(), "OBC");
        assertEq(obc.decimals(), 18);
    }

    function testTransfer() public {
        address recipient = address(0x123);
        obc.mint(100);
        obc.transfer(recipient, 50);
        assertEq(obc.balanceOf(recipient), 50);
    }

    function testApproveAndTransferFrom() public {
        address recipient = address(0x123);
        obc.mint(100);
        obc.approve(recipient, 50);
        obc.transferFrom(address(this), recipient, 50);
        assertEq(obc.balanceOf(recipient), 50);
    }

    function testMint() public {
        obc.mint(100);
        assertEq(obc.balanceOf(address(this)), 100);
    }
}