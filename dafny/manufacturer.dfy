

include "./contract.dfy"
include "Helper.dfy"

class factory extends address{

    var deployedProducts: seq<address>

    constructor(name: string, code: string, quantit: uint, price: uint, supplier: address)
    ensures deployedProducts == old(deployedProducts) + [new manufacturer(name, code, quantity, price, supplier, creater)]
    {
        newProduct = new manufacturer(name, code, quantity, price, supplier, creater);
        deployedProducts := deployedProducts + [newProduct]
    }

}
class manufacturer extends address{
    import openned User

    type User = User<T>

    var manufacturer: address
    var product: Product
    var retailers: array<Retailer>
    var retailerAddresses: array<address>
    var Elements: array

    trait Product {
    var productName: string
    var productCode: string
    var created: bool
    var minimumQuantity: uint
    var priceOfOne: uint
    var supplierAddress: address
    var processed: bool
    }

    trait Retailer{
        var retailer: string
        var quantityOrdered: string
    }

    predicate restrictedToTheProducer(){
        require(this.msg.sender == manufacturer)
    }


    constructor (name: string, code: string, quantity: uint, price: uint, supplier: address, creater: address) {
        ensures product.name == name && product.code == code && product.quantity == quantity 
        ensures product.price == price && product.supplier == supplier && product.creater == creater


    }

    method createNewProduct(name: string, code: string, quantity: uint, price: uint, supplier: address)
    {
        product := new Product(name, code, quantity, price, supplier);
    }

    method orderProduct(quantity: uint, retailerName: string)
        requires product.created
        requires product.minimumQuantity <= quantity
        {
        }

    method orderRawMaterial()

}