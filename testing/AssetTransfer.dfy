include "./contract.dfy"



class AssetTransfer extends address {


	ghost var Elements: seq<address>

	var InstanceAppraiser: address

	var InstanceInspector: address

	var OfferPrice: int

	var InstanceBuyer: address

	var AskingPrice: int

	var InstanceOwner: address

	ghost var Repr1: set<object>

	predicate Invariant()
		reads this, Repr1
		ensures Invariant() ==> Valid() && this in this.Repr1	{
		this in this.Repr1 && this.msg in this.Repr1 && 
		this !in this.msg.Repr && block in Repr1 && this !in block.Repr
	}

	constructor( description: string, price: int)

	method MarkInspected()
		requires Invariant()
		modifies Repr, this
		ensures Invariant() && fresh(Repr-old(Repr))

	method MarkAppraised()
		requires Invariant()
		modifies Repr, this
		ensures Invariant() && fresh(Repr-old(Repr))

	method RescindOffer()
		requires Invariant()
		modifies Repr, this
		ensures Invariant() && fresh(Repr-old(Repr))

	method ModifyOffer( offerPrice: int)
		requires Invariant()
		modifies Repr, this
		ensures Invariant() && fresh(Repr-old(Repr))

	method Accept()
		requires Invariant()
		modifies Repr, this
		ensures Invariant() && fresh(Repr-old(Repr))

	method Reject()
		requires Invariant()
		modifies Repr, this
		ensures Invariant() && fresh(Repr-old(Repr))

	method AcceptOffer()
		requires Invariant()
		modifies Repr, this
		ensures Invariant() && fresh(Repr-old(Repr))

	method MakeOffer( inspector: address, appraiser: address, offerPrice: int)
		requires Invariant()
		modifies Repr, this
		ensures Invariant() && fresh(Repr-old(Repr))

	method Modify( description: string, price: int)
		requires Invariant()
		modifies Repr, this
		ensures Invariant() && fresh(Repr-old(Repr))

	method Terminate()
		requires Invariant()
		modifies Repr, this
		ensures Invariant() && fresh(Repr-old(Repr))
}