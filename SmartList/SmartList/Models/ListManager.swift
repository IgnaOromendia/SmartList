//
//  ListManager.swift
//  SmartList
//
//  Created by Igna on 05/12/2022.
//

import Foundation

class ListManager {
    private var homeLists: Dictionary<String, ListData>
    private var buyLists: Dictionary<String, ListData>
    private var urgents: Set<String>
    
    init(homeLists: Dictionary<String, (list: Dictionary<String, Product>, price: Int)>, buyLists: Dictionary<String, (list: Dictionary<String, Product>, price: Int)>, urgents: Set<String>) {
        self.homeLists = homeLists
        self.buyLists = buyLists
        self.urgents = urgents
    }
    
    convenience init() {
        self.init(homeLists: [:], buyLists: [:], urgents: [])
    }
    
    // MARK: - GET
    
    /// Returns all the list for buying
    func getBuyLists() -> Dictionary<String, ListData> {
        return buyLists
    }
    
    /// Returns all the home lists
    func getHomeLists() -> Dictionary<String, ListData> {
        return homeLists
    }
    
    /// Returns the list corresponding to the id
    func getBuyList(id: String) -> ListData? {
        return buyLists[id]
    }
    
    /// Returns the list corresponding to the id
    func getHomeList(id: String) -> ListData? {
        return homeLists[id]
    }
    
    /// Returns the price of the list corresponding to the id
    func getListPrice(id: String) -> Int {
        if let list = buyLists[id] {
            return list.price
        } else {
            return -1
        }
    }
    
    /// Returns the urgents ids
    func getUrgents() -> Set<String> {
        return urgents
    }
    
    /// Returns True if the id of the list is in the urgent set
    func isUrgent(id: String) -> Bool {
        return self.urgents.contains(id)
    }
    
    // MARK: - SET
    
    /// Creates a new list
    func newList(id: String, type: ListType) throws {
        try validateNewList(id: id, type: type)
        if type == .Buy {
            self.buyLists.updateValue(([:],0), forKey: id)
        } else {
            self.homeLists.updateValue(([:],0), forKey: id)
        }
    }
    
    /// Add a new product to a list
    func newProduct(_ p: Product, id: String) throws {
        var listData: ListData = ([:],0)
        
        // Verifying
        
        if self.buyLists.keys.contains(id) {
            listData = self.buyLists[id]!
        } else if self.homeLists.keys.contains(id) {
            listData = self.homeLists[id]!
        } else {
            throw ListErrors.NonExistingList
        }
        
        // Modifying and Adding
        
        listData.price += (p.amount * p.price)
        
        if listData.list.keys.contains(p.name) {
            var prod = listData.list[p.name]!
            prod.amount += p.amount
            listData.list.updateValue(prod, forKey: prod.name)
        } else {
            listData.list.updateValue(p, forKey: p.name)
        }
        
        // Updating
        
        if self.buyLists.keys.contains(id) {
            self.buyLists.updateValue(listData, forKey: id)
        } else {
            self.homeLists.updateValue(listData, forKey: id)
        }
    }
    
    /// Remove a product from a buying list
    func buyProduct(_ p: Product, idB: String, idH: String) throws {
        var listData: ListData = ([:],0)
        var prod = Product()
        
        // I have to modify the buying list removing the product or reducing the amount of it
        // and then update the original variable
        // Later, add the new product to a home list
        
        // Verifying
        
        if let listDataLET = self.buyLists[idB] {
            listData = listDataLET
        } else {
            throw ListErrors.NonExistingList
        }
        
        // Modifying
        
        listData.price -= p.amount * p.price
        
        if let prodLet = listData.list[p.name] {
            prod = prodLet
        } else {
            throw ListErrors.NonExistingProduct
        }
        
        prod.amount -= p.amount
        
        if prod.amount == 0 {
            listData.list.removeValue(forKey: p.name)
        } else {
            listData.list.updateValue(prod, forKey: prod.name)
        }
        
        // Updating
        
        self.buyLists.updateValue(listData, forKey: idB)
        
        // Adding the product to a home list
        
        // Verifying
        
        if let listDataLET = self.homeLists[idH] {
            listData = listDataLET
        } else {
            throw ListErrors.NonExistingList
        }
        
        if listData.list.keys.contains(p.name) {
            prod = listData.list[p.name]!
            prod.amount += p.amount
            listData.list.updateValue(prod, forKey: prod.name)
        } else {
            listData.list.updateValue(p, forKey: p.name)
        }
        
        // Updating
        
        self.homeLists.updateValue(listData, forKey: idH)
    }
    
    func makeUrgent(id: String) {
        if self.isUrgent(id: id) {
            self.urgents.remove(id)
        } else {
            self.urgents.insert(id)
        }
    }
    
    
    // MARK: - PRIVATE
    
    private func validateNewList(id: String, type: ListType) throws {
        if type == .Buy {
            guard self.buyLists.keys.contains(id) else { throw ListErrors.alreadyAdded }
        } else {
            guard self.buyLists.keys.contains(id) else { throw ListErrors.alreadyAdded }
        }
    }
    
}
