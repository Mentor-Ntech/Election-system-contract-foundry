// "use client";

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/Test.sol";
import '../src/VoterReg.sol';
import '../src/ElectionFactory.sol';

contract DeployElection is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy VoterRegistration contract
        VoterReg voterReg = new VoterReg();
        console.log("VoterReg deployed at:", address(voterReg));

        // Deploy ElectionFactory contract
        ElectionFactory electionFactory = new ElectionFactory();
        console.log("ElectionFactory deployed at:", address(electionFactory));

        vm.stopBroadcast();
    }
}