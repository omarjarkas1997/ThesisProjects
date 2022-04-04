

module User {

    datatype User<T> = Retailer(retailer: string, quantityOrdered: nat) | Product(productName: string, productCode: string, created: bool, minimumQuantity: nat, priceOfOne: nat, address: );

    newtype uint256 = i:int | 0 <= i < 0x10000000000000000000000000000000000000000000000000000000000000000
}