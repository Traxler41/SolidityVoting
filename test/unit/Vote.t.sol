//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Vote} from "../../src/Vote.sol";
import {DeployVote} from "../../script/DeployVote.s.sol";

contract TestVote is Test {
    Vote vote;

    modifier registered() {
        address candidate1 = address(1);
        address candidate2 = address(2);
        vote.register(candidate1);
        vote.register(candidate2);
        _;
    }

    function setUp() external {
        DeployVote deployVote = new DeployVote();
        vote = deployVote.run();
    }

    function testRegistrationOfCandidates() public {
        address candidate1 = address(1);
        address candidate2 = address(2);

        vote.register(candidate1);
        vote.register(candidate2);

        assertEq(0, vote.viewCandidateCode(candidate1));
        assertEq(1, vote.viewCandidateCode(candidate2));
    }

    function testCastVote() public registered {
        vote.castVote(0);

        assertEq(1, vote.viewVoteCounts(0));
    }
}
