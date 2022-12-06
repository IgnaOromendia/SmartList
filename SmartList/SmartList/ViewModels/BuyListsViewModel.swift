//
//  BuyListsViewModel.swift
//  SmartList
//
//  Created by Igna on 06/12/2022.
//

import Foundation

final class BuyListsViewModel {
    private var title: String
    private var list: Dictionary<String,Product>
    private var listArray: Array<Product>
    private var price: String
    
    init(title: String, with data: ListData) {
        self.title = title
        self.price = "$\(data.price)"
        self.list = data.list
        self.listArray = []
        
        for prod in self.list {
            self.listArray.append(prod.value)
        }
    }
    
    convenience init() {
        self.init(title: "", with: ListData())
    }
    
    // GET
    
    func getTitle() -> String {
        return self.title
    }
    
    func getList() -> Dictionary<String,Product> {
        return self.list
    }
    
    func getPrice() -> String {
        return self.price
    }
    
    func getRows() -> Int {
        return self.listArray.count
    }
    
    func getListArray(sortedBy type: SortTypes) -> Array<Product> {
        switch type {
        case .none:
            return self.listArray
        case .name:
            return self.listArray.sorted(by: {$0.name < $1.name})
        case .price:
            return self.listArray.sorted(by: {$0.price > $1.price})
        case .amount:
            return self.listArray.sorted(by: {$0.amount > $1.amount})
        }
    }
    
    // Set
    
    
    
}
