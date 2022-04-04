
contract AWallet{

    address owner;

    mapping(address => unint) public outflow; // keeping a record of the flows the different addresses

    function AWallet(){ // constructor
        owner = msg.sender;     // assigning the owner of the contract to the person who deployed it
    }

    function pay(uint amount, address recipient) returns (bool){
        if(msg.sender != owner || msg.value != 0) throw;
        if(amount > this.balance) return false;
        outflow[recipient] += amount;
        if(!recipient.send(amount)) throw;
        return true;
    }
}