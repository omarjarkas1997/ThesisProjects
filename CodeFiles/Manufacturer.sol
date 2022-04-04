pragma solidity ^0.4.17;



contract ProductFactory{

    address[] public deployedProducts;

    function createProduct(string name, string code, uint quantity, uint price, address supplier) public {
        address newProduct = new Manufacturer(name, code, quantity, price, supplier, msg.sender);
        deployedProducts.push(newProduct);
    }

    function getContracts() public view returns (address[]){
        return deployedProducts;
    }
}


contract Manufacturer{
    
    struct Retailer{
        string retailer;
        uint quantityOrdered;
    }
    
    struct Product{
        string productName;
        string productCode;
        bool created;
        uint minimumQuantity;
        uint priceOfOne;
        address supplierAddress;
        bool processed; 
    }
    
    address public manufacturer;
    Product product;
    Retailer[] retailers;
    address[] retailersAddresses;
    
    modifier restrictedToTheProducer(){
        require(msg.sender == manufacturer);
        _;
    }
    
    function Manufacturer(string name, string code, uint quantity, uint price, address supplier,address creator) public {
        manufacturer = creator;
        createNewProduct(name, code, quantity, price, supplier);
    }
    function createNewProduct(string name, string code, uint quantity, uint price, address supplier) public {
        Product memory newProduct = Product({
        productName: name,
        productCode: code,
        created: true,
        minimumQuantity: quantity,
        priceOfOne: price,
        supplierAddress: supplier,
        processed: false
    });
    
    product = newProduct;
    }
    
    function orderAProduct(uint Quantity, string retailerName) public payable{
        require(product.created); // making sure the the code is to a certain product
        require(product.minimumQuantity <= Quantity);
        Retailer memory newRetailer = Retailer({
            retailer: retailerName,
            quantityOrdered: Quantity
        });
        retailers.push(newRetailer);
        retailersAddresses.push(msg.sender);
    } 
    
    function orderRawMaterial() public{
        require(product.created);
        require(product.processed);
        product.supplierAddress.transfer(address(this).balance);
        retailers.length = 0;
    }
    
    function getRetailers() public view returns (address[]){
        return retailersAddresses;
    }

    function getSummary() public view returns(
        address ,string, string, uint, uint, address, uint
        ) {
        return (
            manufacturer,
            product.productName,
            product.productCode,
            product.minimumQuantity,
            product.priceOfOne,
            product.supplierAddress,
            this.balance
        );
    }

    function getRetailersCount() public view returns (uint){
        return retailers.length;
    }
        
}