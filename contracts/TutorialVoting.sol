// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TutorialVoting {
    mapping(bytes32 => uint256) public votesReceived;
    bytes32[] public candidateList;

    constructor(bytes32[] memory candidateNames) {
        candidateList = candidateNames;
    }

    function setCandidate(bytes32 candidateName) public {
        candidateList.push(candidateName);
    }

    function getAllCandidates() public view returns (bytes32[] memory) {
        return candidateList;
    }

    function totalVotesFor(
        bytes32 candidate
    ) public view returns (uint256) {
        require(validCandidate(candidate), "Invalid candidate");
        return votesReceived[candidate];
    }

    function voteForCandidate(bytes32 candidate) public {
        require(validCandidate(candidate), "Invalid candidate");
        votesReceived[candidate] += 1;
    }

    function validCandidate(bytes32 candidate) public view returns (bool) {
        for (uint256 i = 0; i < candidateList.length; i++) {
            if (candidateList[i] == candidate) {
                return true;
            }
        }

        return false;
    }
}
