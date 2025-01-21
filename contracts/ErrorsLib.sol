// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library ErrorsLib {

    error InexistingVote();
    error VoteEnded();
    error NeedCanVoteToken();
    error InvalidOption();
    error VoteAlreadyDone();
}