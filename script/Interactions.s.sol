//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {Vote} from "../src/Vote.sol";

contract VoteVote is Script {
    function registerCandidates(address mostRecentlyDeployed) public {
        address candidate1 = address(1);
        address candidate2 = address(2);
        Vote(mostRecentlyDeployed).register(candidate1);
        Vote(mostRecentlyDeployed).register(candidate2);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "Vote",
            block.chainid
        );
        vm.startBroadcast();
        registerCandidates(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}

contract VoteCast is Script {
    function giveVote(address mostRecentlyDeployed) public {
        address candidate1 = address(1);
        address candidate2 = address(2);

        Vote(mostRecentlyDeployed).register(candidate1);
        Vote(mostRecentlyDeployed).register(candidate2);

        Vote(mostRecentlyDeployed).castVote(1);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "Vote",
            block.chainid
        );
        vm.startBroadcast();
        giveVote(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}

contract DuplicateRegistration is Script {
    function registerTwice(address mostRecentlyDeployed) public {
        address cadreAddress = address(5);
        Vote(mostRecentlyDeployed).register(cadreAddress);
        Vote(mostRecentlyDeployed).register(cadreAddress);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "Vote",
            block.chainid
        );
        vm.startBroadcast();
        registerTwice(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}
