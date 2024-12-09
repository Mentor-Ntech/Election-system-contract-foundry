// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./Election.sol";


contract ElectionFactory {
    struct ElectionDetail {
        string stateName;
        address electionAddress;
    }

    ElectionDetail[] public elections;

    function deployElection(string memory stateName) external {
        Election newElection = new Election();
        elections.push(ElectionDetail({ stateName: stateName, electionAddress: address(newElection) }));
    }

        function addCandidatesToElection(address electionAddress, string[] memory candidateNames) external {
        // Create a new instance of an existing Election smart contract.
        Election election = Election(electionAddress);

        for (uint256 i = 0; i < candidateNames.length; i++) {
            // Call the newly added function from within your ElectionsFactory
            election.addCandidateVote(candidateNames[i]);
        }
    }

    function getAllElections() external view returns (ElectionDetail[] memory) {
        return elections;
    }
}