

    trait address{
        var balance: nat
        var msg: Message
        var block: Block
        ghost var Repr: set<object>

        predicate Valid()
            reads this, Repr
            ensures Valid() ==> this in Repr
            {
                this in Repr && 
                msg in Repr && this !in msg.Repr &&
                block in Repr && this !in block.Repr
            }

        
        method transfer(payer: address)
        requires payer.msg.value < payer.balance
        requires payer != this
        requires Valid()
        modifies Repr, payer
        ensures balance == old(balance) + payer.msg.value 
        ensures payer.balance == old(payer.balance) - payer.msg.value
        ensures Valid()
        {
            assert old(balance) == balance;
            balance := balance + payer.msg.value;
            assert old(balance) + payer.msg.value == balance;
            payer.balance := payer.balance - payer.msg.value;
            assert old(balance) + payer.msg.value == balance;
        }

        method send(amount: nat, sender:address)
            requires sender.balance > amount
            requires Valid()
            modifies Repr
            ensures this.balance == old(this.balance) + amount
            {
                this.balance := this.balance + amount;
            }

    }

    trait Message{

        var sender: address
        var value: nat
        var data: nat
        var Repr: set<object>
    }

    trait Block{

        var timestamp: nat
        var coinbase: address
        var difficulty: nat
        var gaslimit: nat
        var number: nat
        var Repr: set<object>


    }

    module remixAddress{

        function listofAddresses() :seq<seq<char>>
        {        
            [
            "0x0EfD2fEC66633f663F05e952dC21FdF1EBc9BB67",
            "0xcb24700E70C5EcadbBA188363DB49D7d48BFE14d",
            "0xB651923e174Ff80b22Eb2202E146b026752002B1",
            "0xBf5a0508e458747c1207db30706113CEE03f1f48",
            "0xD7F92FbCAd676EAC52ca4D65467877D5bdcC88BB",
            "0xCf5cfd7f3d59a3ac90691734c10459fFB48A1d14",
            "0xC66EA0BFa181c8649AB845eB4211329Ff064587F",
            "0x5b7189Ed2A62737aadB25e7f04654f12f9392d00",
            "0x957bed47125B0311b31447aBa58554214A287246",
            "0x583031D1113aD414F02576BD6afaBfb302140225",
            "0xdD870fA1b7C4700F2BD7f44238821C26f7392148"
            ]
        }
    }
