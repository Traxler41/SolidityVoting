//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {console} from "forge-std/Test.sol";

error AlreadyRegistered(address recordedCandidate, uint recordedCandidateCode);
error AlreadyVoted(address voter);
error IncorrectCandidateCode(uint ccode);

contract Vote {
    uint candidateCode = 0;

    mapping(address => uint) registeredCandidate;
    mapping(uint => address) reverseRegisteredCandidate;
    mapping(uint => uint) voteCount;
    mapping(address => bool) voterRecord;

    function register(address _candidate) public {
        address candidate = _candidate;
        if (
            candidate ==
            reverseRegisteredCandidate[registeredCandidate[candidate]]
        ) {
            revert AlreadyRegistered(candidate, registeredCandidate[candidate]);
        }

        registeredCandidate[candidate] = candidateCode;
        reverseRegisteredCandidate[candidateCode++] = candidate;
        console.log("Candidate Registered...");
    }

    function castVote(uint _candidateCode) public {
        uint code = _candidateCode;
        if (voterRecord[address(msg.sender)] == true) {
            revert AlreadyVoted(address(msg.sender));
        }
        voterRecord[address(msg.sender)] = true;
        vote(code);
    }

    function vote(uint _candidateCode) private {
        uint code = _candidateCode;
        if (code != registeredCandidate[reverseRegisteredCandidate[code]]) {
            revert IncorrectCandidateCode(code);
        }

        uint initialVote = voteCount[code];
        initialVote = initialVote + 1;
        voteCount[code] = initialVote;
    }

    function viewResults() public view {
        for (uint i = 0; i < candidateCode; i++) {
            console.log(
                "Address:-",
                reverseRegisteredCandidate[i],
                " and votes received:-",
                voteCount[i]
            );
        }
    }

    function viewCandidateCode(
        address _candidateAddress
    ) public view returns (uint) {
        address candidateAddress = _candidateAddress;
        return registeredCandidate[candidateAddress];
    }

    function viewCandidateAddress(uint _code) public view returns (address) {
        uint code = _code;
        return reverseRegisteredCandidate[code];
    }

    function viewVoteCounts(uint _code) public view returns (uint) {
        uint code = _code;
        return voteCount[code];
    }
}
