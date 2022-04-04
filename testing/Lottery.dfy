include "./contract.dfy"



class Lottery extends address {


	ghost var Elements: seq<address>

	var players: array<address>

	ghost var Repr1: set<object>

	predicate Invariant()
		reads this, Repr1
		ensures Invariant() ==> Valid() && this in this.Repr1	{
		this in this.Repr1 && this.msg in this.Repr1 && 
		this !in this.msg.Repr && block in Repr1 && this !in block.Repr
	}

	constructor ()

	method getPlayers()   returns (r:address)
		requires Invariant()
		modifies Repr, this
		ensures Invariant() && fresh(Repr-old(Repr))

	method OnlyManagerCanCall()
		requires Invariant()
		modifies Repr, this
		ensures Invariant() && fresh(Repr-old(Repr))

	method pickWinner()
		requires Invariant()
		modifies Repr, this
		ensures Invariant() && fresh(Repr-old(Repr))

	method random() returns (r:int)
		requires Invariant()
		modifies Repr, this
		ensures Invariant() && fresh(Repr-old(Repr))

	method enterPlayerToLottery()
		requires Invariant()
		modifies Repr, this
		ensures Invariant() && fresh(Repr-old(Repr))
}