// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Dao{
    address public owner;
    uint public votingDeadline;
    uint public voteCost = 0.01 ether;

    struct Candidate{
        string name;
        uint voteCount;
    }

    constructor(uint durationInMinutes){
        owner = msg.sender;
        votingDeadline = block.timestamp + durationInMinutes * 1 minutes;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    modifier beforeDeadline(){
        require(block.timestamp < votingDeadline, "Voting has already ended");
        _;
    }

    Candidate[] public candidates;
    mapping(address => bool) public hasVoted;

    event CandidateAdded(string name);

    function addCandidate(string memory _name) public onlyOwner beforeDeadline {
        candidates.push(Candidate(_name, 0));
        emit CandidateAdded(_name);
    }

    function getCandidateCount() public view returns(uint){
        return candidates.length;
    }

    function vote(uint candidateIndex) external payable beforeDeadline{
        require(candidateIndex < candidates.length, "invalid index");
        require(!hasVoted[msg.sender], "You have already voted");
        require(msg.value>= voteCost, "Insufficient payment for vote");
        candidates[candidateIndex].voteCount++;
        hasVoted[msg.sender] = true;
    }

    function getCandidates() public view returns(Candidate[] memory){
        return candidates;
    }
}
