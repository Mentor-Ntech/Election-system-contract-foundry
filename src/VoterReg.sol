// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;


contract VoterReg {
    
    address public electoralBoard;
    mapping (address => bool ) public registeredVoters;

    modifier onlyElectoralBoard() {
        require(msg.sender == electoralBoard);

        _;
    }


    constructor() {
        electoralBoard = msg.sender;
    }

    function registerVoter(address voter) external onlyElectoralBoard {
        require(!registeredVoters[voter], "Voter is already registered");
        registeredVoters[voter] = true;
    }

    function isVoterRegistered(address voter) external view returns (bool) {
        return registeredVoters[voter];
    }
}