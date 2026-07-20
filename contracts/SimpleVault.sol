// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SimpleVault {
    address public owner;

    event Deposited(address indexed sender, uint256 amount);
    event Withdrawn(address indexed receiver, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function deposit() public payable {
        require(msg.value > 0, "Send some ETH");
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        require(msg.sender == owner, "Only owner");
        require(address(this).balance >= amount, "Insufficient balance");

        payable(owner).transfer(amount);
        emit Withdrawn(owner, amount);
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
