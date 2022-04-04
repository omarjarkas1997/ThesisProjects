


module metaData{
    class message{
    var data: string
    var gas: int 
    var sender: string 
    var value: string 
    ghost var Repr: set<object>

    predicate Valid()
        reads this
    constructor()
        ensures Valid()
}
}

class Retailer{

    const retailer: string
    var quantityOrdered: nat

    ghost var Repr: set<object>


    predicate Valid()
        reads this
        ensures Valid() ==> this in Repr
        {
            this in Repr && 
            retailer != "" && quantityOrdered < 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        }

    constructor()
        ensures Valid()

}
class Product{


    var productName: string
    var productCode: string
    var created: bool
    var minimumQuntity: string
    var priceOfOne: nat

    var supplierAddress: string

    var processed: string

    ghost var Repr: set<object>

    predicate Valid()
        reads this, Repr
        ensures Valid() ==> this in Repr
        {
            this in Repr 
        }

    constructor(name: string, code: string, quantity: nat, price: nat, supplier: string)
        ensures Valid()
        ensures created == true && productName == name && productCode == code && priceOfOne == price && supplierAddress == supplier

}

class Manufacturer {


    var product: Product
    var retailer: Retailer
    var msg: metaData.message

    var creator: string

    ghost var Repr: set<object>

    predicate Valid()
        reads this, Repr
        ensures Valid() ==> this in Repr
        {
            this in Repr &&
            product in Repr && product.Repr <= Repr &&  product.Valid() &&
            retailer in Repr && retailer.Repr <= Repr && retailer.Valid() &&
            product.created 
        }


    constructor(name: string, code: string, quantity: nat, price: nat, supplier: string)
        requires name != "" && code != "" && quantity != 0 && price != 0 && supplier != "" 
        ensures creator == msg.value
        {
            product := new Product(name, code, quantity, price, supplier);
            retailer := new Retailer();
            Repr := {this, product, retailer};
        }

    method createNewProduct(name: string, code: string, quantity: nat, price: nat, supplier: string)
        requires Valid()
        ensures product.created == true 
        ensures product.productName == name
        ensures product.productCode == code 
        ensures product.priceOfOne == price 
        ensures product.supplierAddress == supplier 
        ensures Valid()

        
}