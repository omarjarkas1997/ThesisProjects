include "Contract.dfy"

module Auction {
    import opened Contract
    class auction {

    
    ghost var Elements: seq<(address,nat)>
    var beneficiary: address?
    var auctionEnd: nat
    var highestBidder: address?
    var highestBid: nat
    var pendingReturns: map<address, nat>
    var ended: bool


    predicate Invariant()
        reads this
        {
            (|pendingReturns| == 0 ==> |Elements| == 0) &&
            (forall i:: i in pendingReturns.Keys ==> pendingReturns[i] <= this.balance)
        }

    }
}