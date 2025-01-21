// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Vote.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract VoteFactory is Ownable {
    address public tokenAddress;
    address[] public votes;

    constructor(address _tokenAddress) Ownable(msg.sender) {
        tokenAddress = _tokenAddress;
    }

    function createVote(string memory question, string[4] memory answers) public onlyOwner {
        Vote newVote = new Vote(tokenAddress);
        votes.push(address(newVote));
        newVote.createVote(question, answers);
    }

    function getVotes() public view returns (address[] memory) {
        return votes;
    }

    function getVote(uint256 index) public view returns (address) {
        require(index < votes.length, "Index out of bounds");
        return votes[index];
    }

    function getVotesCount() public view returns (uint256) {
        return votes.length;
    }
}
