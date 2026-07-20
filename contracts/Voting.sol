// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Voting {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    address public owner;
    Candidate[] public candidates;
    mapping(address => bool) public hasVoted;

    event Voted(address indexed voter, uint256 indexed candidateId);

    constructor(string[] memory candidateNames) {
        owner = msg.sender;

        for (uint256 i = 0; i < candidateNames.length; i++) {
            candidates.push(
                Candidate({
                    name: candidateNames[i],
                    voteCount: 0
                })
            );
        }
    }

    function vote(uint256 candidateId) public {
        require(!hasVoted[msg.sender], "Already voted");
        require(candidateId < candidates.length, "Invalid candidate");

        hasVoted[msg.sender] = true;
        candidates[candidateId].voteCount += 1;

        emit Voted(msg.sender, candidateId);
    }

    function getCandidateCount() public view returns (uint256) {
        return candidates.length;
    }
}
