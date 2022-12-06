//
//  Product.swift
//  SmartList
//
//  Created by Igna on 06/12/2022.
//

import Foundation

class Product {
    let name: String
    let price: Int
    var amount: Int
    
    init(name: String, price: Int, amount: Int) {
        self.name = name
        self.price = price
        self.amount = amount
    }
    
    convenience init() {
        self.init(name: "", price: 0, amount: 0)
    }
    
}
