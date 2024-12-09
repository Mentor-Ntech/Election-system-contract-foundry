// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


contract Election {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    struct Voter {
        bool hasVoted;
        address delegate;
        uint256 voteWeight;
    }

    address public electionFactory;
    Candidate[] public candidates;
    mapping(address => Voter) public voters;
    bool public electionEnded;

    modifier onlyElectionFactory() {
        require(msg.sender == electionFactory, "Only the election factory can perform this action");
        _;
    }

    modifier onlyRegisteredVoter(address voter) {
        require(voters[voter].voteWeight > 0, "Voter not registered or has no voting weight");
        _;
    }

    constructor() {
        electionFactory = msg.sender;
    }


    function addCandidateVote(string memory name) external onlyElectionFactory {
        candidates.push(Candidate({ name: name, voteCount: 0 }));
    }

    function registerVoter(address voter) external onlyElectionFactory {
        require(voters[voter].voteWeight == 0, "Voter already registered");
        voters[voter] = Voter({ hasVoted: false, delegate: address(0), voteWeight: 1 });
    }

    function delegateVote(address to) external onlyRegisteredVoter(msg.sender) {
        require(to != msg.sender, "Cannot delegate to yourself");
        require(!voters[msg.sender].hasVoted, "Already voted");
        
        address current = to;
        while (voters[current].delegate != address(0)) {
            current = voters[current].delegate;
            require(current != msg.sender, "Circular delegation detected");
        }

        voters[msg.sender].hasVoted = true;
        voters[msg.sender].delegate = to;

        if (voters[to].hasVoted) {
            candidates[voters[to].voteWeight].voteCount += voters[msg.sender].voteWeight;
        } else {
            voters[to].voteWeight += voters[msg.sender].voteWeight;
        }
    }

    function vote(uint256 candidateIndex) external onlyRegisteredVoter(msg.sender) {
        require(!voters[msg.sender].hasVoted, "Already voted");
        require(candidateIndex < candidates.length, "Invalid candidate");

        voters[msg.sender].hasVoted = true;
        candidates[candidateIndex].voteCount += voters[msg.sender].voteWeight;
    }

    function endElection() external onlyElectionFactory {
        require(!electionEnded, "Election already ended");
        electionEnded = true;
    }

    function getWinner() external view returns (string memory) {
        require(electionEnded, "Election has not ended yet");

        uint256 winningVoteCount = 0;
        string memory winnerName;

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].voteCount > winningVoteCount) {
                winningVoteCount = candidates[i].voteCount;
                winnerName = candidates[i].name;
            }
        }

        return winnerName;
    }


}