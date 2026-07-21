// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MyToken {
    mapping(address => uint256) public balanceOf;

    constructor(uint256 initialSupply) {
        balanceOf[msg.sender] = initialSupply;
    }

    function mint(address recipient, uint256 amount) public {
        balanceOf[recipient] += amount;
    }

    function transfer(address recipient, uint256 amount) public {
        require(
            balanceOf[msg.sender] >= amount,
            "Insufficient token balance"
        );

        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
    }
}
