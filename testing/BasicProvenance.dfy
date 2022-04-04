include "./contract.dfy"



class BasicProvenance extends address {


	ghost var Elements: seq<address>

	var SupplyChainObserver: address

	var SupplyChainOwner: address

	var PreviousCounterparty: address

	var Counterparty: address

	var InitiatingCounterparty: address

	ghost var Repr1: set<object>

	predicate Invariant()
		reads this, Repr1
		ensures Invariant() ==> Valid() && this in this.Repr1	{
		this in this.Repr1 && this.msg in this.Repr1 && 
		this !in this.msg.Repr && block in Repr1 && this !in block.Repr
	}

	constructor( supplyChainOwner: address, supplyChainObserver: address)

	method Complete()
		requires Invariant()
		modifies Repr, this
		ensures Invariant() && fresh(Repr-old(Repr))

	method TransferResponsibility( newCounterparty: address)
		requires Invariant()
		modifies Repr, this
		ensures Invariant() && fresh(Repr-old(Repr))
}