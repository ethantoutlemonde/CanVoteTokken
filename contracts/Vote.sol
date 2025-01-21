// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./ErrorsLib.sol";

contract Vote is Ownable {
    struct VoteDetails {
        string question;
        string[4] answers;
        uint256 startTime;
        uint256[4] votes;
    }

    mapping(address => bool) hasVoted;

    IERC20 public canVoteToken;
    mapping(uint256 => VoteDetails) public votes;
    uint256 public votesCount;
    event VoteCreated(uint256 voteId, string question, string[4] answers, uint256 startTime);
    event Voted(uint256 voteId, address voter, uint256 answerIndex);
    
    constructor(address tokenAddress) Ownable(msg.sender) {
        canVoteToken = IERC20(tokenAddress);
    }

    function createVote(string memory question, string[4] memory answers) public onlyOwner {
        votes[votesCount].question = question;
        votes[votesCount].answers = answers;
        votes[votesCount].startTime = block.timestamp;
        emit VoteCreated(votesCount, question, answers, block.timestamp);
        votesCount++;
    }

    function vote(uint256 voteId, uint256 answerIndex) public {
        require(voteId < votesCount, ErrorsLib.InexistingVote());
        require(block.timestamp <= votes[voteId].startTime + 1 days, ErrorsLib.VoteEnded());
        require(hasVoted[msg.sender], ErrorsLib.VoteAlreadyDone());
        require(canVoteToken.balanceOf(msg.sender) > 0, ErrorsLib.NeedCanVoteToken());
        require(answerIndex < 4, ErrorsLib.InvalidOption());

        hasVoted[msg.sender] = true;
        votes[voteId].votes[answerIndex]++;

        emit Voted(voteId, msg.sender, answerIndex);
    }

    function getVoteDetails(uint256 voteId)
        public
        view
        returns (string memory question, string[4] memory answers, uint256[4] memory votesCount)
    {
        require(voteId < votesCount.length, ErrorsLib.InexistingVote());

        VoteDetails memory vote = votes[voteId];
        return (vote.question, vote.answers, vote.votes);
    }
}
