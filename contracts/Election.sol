pragma solidity ^0.4.17;

contract Election {
	struct Voter {
		uint weight;
		bool voted;
		uint8 vote;
	}

	// Modifier
	modifier onlyOwner() {
		require(msg.sender == admin);
		_;
	}

	address public admin;
	mapping(address => Voter) public voters;
	uint[10] public parties;

	// Decide admin
	function Election() public {
		admin = msg.sender;
	}

	// Allow admin to register a voter
	function register(address toVoter) public onlyOwner{
		// Revert if already registered
		if(voters[toVoter].weight != 0) revert();
		voters[toVoter].weight = 1; // ONE vote per person
		voters[toVoter].voted = false;
	}

	// Allow a voter to vote to a party
	function vote(uint8 toParty) public {
		Voter storage sender = voters[msg.sender];
		// Limited to 10 parties only
		if(sender.voted || toParty >= 10 || sender.weight == 0)
			revert();
		sender.voted = true;
		sender.vote = toParty;
		parties[toParty] += sender.weight;
	}

	// Find the winning party
	function winningParty() public constant returns (uint8 _winningParty) {
		uint256 winningVoteCount = 0;
		for(uint8 num = 0; num < 10; num++)
			if(parties[num] > winningVoteCount){
				winningVoteCount = parties[num];
				_winningParty = num;
			}
	}

	// Get the count of all proposals
	function getCount() public constant returns (uint[10]) {
		return parties;
	}
}
