pragma solidity ^0.4.17;

contract Election {
	struct Voter {
		uint weight;
		bool voted;
		uint8 vote;
	}

	address public admin;
	mapping(address => Voter) public voters;
	uint[10] public proposals;

	// Decide admin
	function Election() public {
		admin = msg.sender;
	}

	// Register a voter
	function register(address toVoter) public {
		// Revert if already registered
		if(voters[toVoter].weight != 0) revert();
		voters[toVoter].weight = 1; // ONE vote per person
		voters[toVoter].voted = false;
	}

	function vote(uint8 toProposal) public {
		Voter storage sender = voters[msg.sender];
		// Limited to 10 proposals only
		if(sender.voted || toProposal >= 10 || sender.weight == 0)
			revert();
		sender.voted = true;
		sender.vote = toProposal;
		proposals[toProposal] += sender.weight;
	}

	function winningProposal() public constant returns (uint8 _winningProposal) {
		uint256 winningVoteCount = 0;
		for(uint8 prop = 0; prop < 10; prop++)
			if(proposals[prop] > winningVoteCount){
				winningVoteCount = proposals[prop];
				_winningProposal = prop;
			}
	}

	function getCount() public constant returns (uint[4]) {
		return proposals;
	}
}
