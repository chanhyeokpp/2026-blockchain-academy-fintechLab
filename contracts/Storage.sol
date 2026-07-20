// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Storage {
    uint256 private storedValue;

    event ValueChanged(uint256 newValue, address changedBy);

    function setValue(uint256 newValue) public {
        storedValue = newValue;
        emit ValueChanged(newValue, msg.sender);
    }

    function getValue() public view returns (uint256) {
        return storedValue;
    }
}
