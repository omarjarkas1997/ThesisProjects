



pragma solidity ^0.4.22;


contract Lottery{
    
    address public manager; 
    address[] public players;
    
    
    constructor () public {
        manager = msg.sender;
    }
    
    // array of address for player who payed money to join to Lottery
    // since we are expect thay the invoker of the function to send some monet to be include in the lottery the function some be a type payable
    function enterPlayerToLottery() public payable{
        require(msg.value > 0.01 ether); //must make sure the the minimum amount a person can send to cen into the lottery is 0.1 ether
        players.push(msg.sender);
    }
    
    function random() private view returns (uint){  
        // keccak return a long number in hexa decimal
        return uint(keccak256(block.difficulty, now, players));    
    }
    
    function pickWinner() public  {
        // requires players.length != 01
        // ensures 0 <= index <= players.length
        uint index = random() % players.length;
        players[index].transfer(this.balance); // balance is the amount of money inside the contract
        // restting the contract
        players = new address[](0); // inital size of size for a dynamic array
    }
    
    // are use to reducing the code 
    modifier OnlyManagerCanCall(){
        require(msg.sender == manager);
        _;
    }
    
    
    
    function getPlayers() public view returns (address[]){
        return players;
    }
    
    
}