//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Vote} from "../../src/Vote.sol";
import {DevOpsTools} from "../../lib/foundry-devops/src/DevOpsTools.sol";
import {DeployVote} from "../../script/DeployVote.s.sol";
import {VoteVote, VoteCast, DuplicateRegistration} from "../../script/Interactions.s.sol";

contract VoteTestIntegration is Test {
    Vote vote;
    address USER = makeAddr("user");

    function setUp() external {
        DeployVote deployVote = new DeployVote();
        vote = deployVote.run();
    }

    function testCandidatesCanRegister() public {
        VoteVote voteVote = new VoteVote();
        voteVote.registerCandidates(address(vote));

        address registeredCandidateAddress = vote.viewCandidateAddress(0);
        address registeredCandidateAddress2 = vote.viewCandidateAddress(1);
        assertEq(address(1), registeredCandidateAddress);
        assertEq(address(2), registeredCandidateAddress2);
    }

    function testVotersCanCastVotes() public {
        VoteCast voteCast = new VoteCast();
        voteCast.giveVote(address(vote));

        console.log(
            "Votes received by the second Candidate:-",
            vote.viewVoteCounts(1)
        );

        assertEq(1, vote.viewVoteCounts(1));
    }

    function testCandidatesCannotRegisterTwice() public {
        DuplicateRegistration duplicateRegistration = new DuplicateRegistration();

        vm.expectRevert();
        duplicateRegistration.registerTwice(address(vote));
    }
}
