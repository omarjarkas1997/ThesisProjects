include "./contract.dfy"



class auction extends address{

    ghost var Elements: seq<(address,nat)>
    var beneficiary: address?
    var auctionEnd: nat
    var highestBidder: address?
    var highestBid: nat
    var pendingReturns: map<address,nat>
    var ended: bool

    predicate Invaraint()
        reads this, Repr
        ensures Invaraint() ==> Valid() && this in this.Repr
    {
        this in this.Repr && this.msg in this.Repr && 
        this !in this.msg.Repr && block in Repr &&
            this !in block.Repr && 
            !ended && 
            |Elements| == 0 &&
            |Elements| == |pendingReturns.Keys| &&
            (|pendingReturns| == 0 ==> |Elements| == 0) &&
            (forall  i :: i in pendingReturns.Keys ==> 
                        pendingReturns[i] <= this.balance) &&
            this.balance >= highestBid
    }

    constructor(biddingTime: nat,beneficiary: address)
        ensures Invaraint()
        ensures this.beneficiary == beneficiary
        ensures auctionEnd == block.timestamp + biddingTime
        {
            balance := 0;
            highestBidder := null;
            highestBid := 0;
            ended := false;
            pendingReturns := map[];
            Elements := [];
            new;
            this.block.timestamp := 1;
            this.beneficiary := beneficiary;
            auctionEnd := this.block.timestamp;
            this.Repr := {this, this.msg, this.block};
        }
    
    // TODO: add ghost variable map pending returns
    method bid(payer: address)
        requires payer.msg.value > highestBid
        requires payer.block.timestamp <= auctionEnd
        requires Invaraint()
        modifies Repr,this
        ensures forall i :: i in pendingReturns ==> pendingReturns[i] <= payer.msg.value
        ensures highestBid > old(highestBid)
        ensures highestBidder == old(highestBidder) ==> pendingReturns.Keys == old(pendingReturns.Keys)
        ensures Invaraint() && fresh(this.Repr-old(this.Repr))
        ensures if highestBid == 0 then |pendingReturns.Keys| == 0 else  pendingReturns == old(pendingReturns)[old(highestBidder):= (if highestBidder in pendingReturns then pendingReturns[highestBidder] else 0) + highestBid
        {
            if highestBid != 0 {
                pendingReturns := pendingReturns[highestBidder:= (if highestBidder in pendingReturns then pendingReturns[highestBidder] else 0) + highestBid];
            }
            highestBidder := payer.msg.sender;
            highestBid := payer.msg.value;
        }

    method withdraw(caller:address)
        requires Valid()
        modifies this, Repr
        ensures Valid()
        ensures pendingReturns == old(map add | add in pendingReturns.Keys && add != caller :: pendingReturns[add])
        {
            var amount := if caller in pendingReturns then pendingReturns[caller] else 0;
            assert amount <= this.balance;
            pendingReturns := pendingReturns[caller:= 0];
            this.balance := this.balance - amount;
            caller.send(amount,this);
        }

}

