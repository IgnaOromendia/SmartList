//
//  SmartListTests.swift
//  SmartListTests
//
//  Created by Igna on 05/12/2022.
//

import XCTest
@testable import SmartList

final class ListManagerTests: XCTestCase {
    
    var listManager = ListManager()
    let listID1 = "L1"
    let listID2 = "L2"
    let expectedEmptyList1 = ["L1":ListData()]
    let expectedEmptyList2 = ["L2":ListData()]
    let product1 = Product(name: "Milk", price: 10, amount: 1)
    let product2 = Product(name: "Milk", price: 10, amount: 4)
    let product3 = Product(name: "Milk", price: 10, amount: 5)
    
    func test_creatingNewList() {
        do {
            try listManager.newList(id: listID1, type: .Buy)
            try listManager.newList(id: listID2, type: .Home)
        } catch {
            print(error.localizedDescription)
        }
    
        XCTAssert(listManager.getBuyLists() == expectedEmptyList1)
        XCTAssert(listManager.getHomeLists() == expectedEmptyList2)
        XCTAssert(listManager.getListPrice(id: listID1) == 0)
        XCTAssert(listManager.getListPrice(id: listID2) == -1)

    }
    
    func test_creatingAnExitingList() throws {
        try listManager.newList(id: listID1, type: .Buy)
        try listManager.newList(id: listID2, type: .Home)
        
        XCTAssertThrowsError(try listManager.newList(id: listID1, type: .Buy))
        XCTAssertThrowsError(try listManager.newList(id: listID2, type: .Home))
        
        XCTAssert(listManager.getBuyLists() == expectedEmptyList1)
        XCTAssert(listManager.getHomeLists() == expectedEmptyList2)
    }
    
    func test_newProduct() {
        let expectedSingleList = ListData(list: ["Milk":product1], price: 10)
        
        do {
            try listManager.newList(id: listID1, type: .Buy)
            try listManager.newProduct(product1, id: listID1)
            
            try listManager.newList(id: listID2, type: .Home)
            try listManager.newProduct(product1, id: listID2)
        } catch {
            print(error.localizedDescription)
        }
        
        XCTAssert(listManager.getBuyList(id: listID1) == expectedSingleList)
        XCTAssert(listManager.getHomeList(id: listID2) == expectedSingleList)
    }
    
    func test_newProductAlreadyAdded() {
        let expectedSingleList = ListData(list: ["Milk":product3], price: 10)
        do {
            try listManager.newList(id: listID1, type: .Buy)
            try listManager.newProduct(product1, id: listID1)
            try listManager.newProduct(product2, id: listID1)
            
            try listManager.newList(id: listID2, type: .Home)
            try listManager.newProduct(product1, id: listID2)
            try listManager.newProduct(product2, id: listID2)
            
        } catch {
            print(error.localizedDescription)
        }
        
        
        XCTAssert(listManager.getBuyList(id: listID1) == expectedSingleList)
        XCTAssert(listManager.getHomeList(id: listID2) == expectedSingleList)
    }
    
    func test_buyProductTotal() {
        let expectedSingleList = ListData(list: ["Milk":product1], price: 10)
        
        do {
            try listManager.newList(id: listID1, type: .Buy)
            try listManager.newList(id: listID2, type: .Home)
            try listManager.newProduct(product1, id: listID1)
            try listManager.buyProduct(product1, idB: listID1, idH: listID2)
        } catch {
            print(error.localizedDescription)
        }
        
        XCTAssertTrue(listManager.getBuyList(id: listID1)!.list.isEmpty)
        XCTAssert(listManager.getBuyList(id: listID1)!.price == 0)
        XCTAssert(listManager.getHomeList(id: listID2) == expectedSingleList)
        
    }
    
    func test_buyProductAlreadyInHome() {
        let expectedSingleList = ListData(list: ["Milk":product3], price: 10)
        
        do {
            try listManager.newList(id: listID1, type: .Buy)
            try listManager.newList(id: listID2, type: .Home)
            try listManager.newProduct(product1, id: listID1)
            try listManager.newProduct(product2, id: listID2)
            try listManager.buyProduct(product1, idB: listID1, idH: listID2)
        } catch {
            print(error.localizedDescription)
        }
        
        XCTAssertTrue(listManager.getBuyList(id: listID1)!.list.isEmpty)
        XCTAssert(listManager.getBuyList(id: listID1)!.price == 0)
        XCTAssert(listManager.getHomeList(id: listID2) == expectedSingleList)
        
    }
    
    func test_buyProductPart() {
        let expectedSingleList1 = ListData(list: ["Milk":product2], price: 10)
        let expectedSingleList2 = ListData(list: ["Milk":product1], price: 10)
        
        do {
            try listManager.newList(id: listID1, type: .Buy)
            try listManager.newList(id: listID2, type: .Home)
            try listManager.newProduct(product3, id: listID1)
            try listManager.buyProduct(product2, idB: listID1, idH: listID2)
        } catch {
            print(error.localizedDescription)
        }
        
        XCTAssertTrue(listManager.getBuyList(id: listID1) == expectedSingleList2)
        XCTAssert(listManager.getBuyList(id: listID1)!.price == 10)
        XCTAssert(listManager.getHomeList(id: listID2) == expectedSingleList1)
        
    }
    
    func test_buyProductNonExistingBuyList() throws {
        do {
            //try listManager.newList(id: listID1, type: .Buy)
            try listManager.newList(id: listID2, type: .Home)
            //try listManager.newProduct(product1, id: listID1)
            
        } catch {
            print(error.localizedDescription)
        }
        XCTAssertThrowsError(try listManager.buyProduct(product1, idB: listID1, idH: listID2))
    }
    
    func test_buyProductNonExistingHomeList() throws {
        do {
            try listManager.newList(id: listID1, type: .Buy)
            //try listManager.newList(id: listID2, type: .Home)
            try listManager.newProduct(product1, id: listID1)
            
        } catch {
            print(error.localizedDescription)
        }
        XCTAssertThrowsError(try listManager.buyProduct(product1, idB: listID1, idH: listID2))
    }
    
    func test_buyProductNonExisting() throws {
        do {
            try listManager.newList(id: listID1, type: .Buy)
            try listManager.newList(id: listID2, type: .Home)
            //try listManager.newProduct(product1, id: listID1)
            
        } catch {
            print(error.localizedDescription)
        }
        XCTAssertThrowsError(try listManager.buyProduct(product1, idB: listID1, idH: listID2))
    }
    
    func test_urgentList() {
        do {
            try listManager.newList(id: listID1, type: .Buy)
            try listManager.newList(id: listID2, type: .Home)
        } catch {
            print(error.localizedDescription)
        }
        
        listManager.makeUrgent(id: listID1)
        listManager.makeUrgent(id: listID2)
        
        XCTAssert(listManager.getUrgents() == [listID1,listID2])
        
        listManager.makeUrgent(id: listID1)
        
        XCTAssert(listManager.getUrgents() == [listID2])
        
        listManager.makeUrgent(id: listID2)
        
        XCTAssert(listManager.getUrgents().isEmpty)
    }
    
    func test_startingLists() {
        do {
            try listManager.newList(id: listID1, type: .Buy)
            try listManager.newList(id: listID2, type: .Home)
            try listManager.newList(id: "sB", type: .Buy)
            try listManager.newList(id: "sH", type: .Home)
        } catch {
            print(error.localizedDescription)
        }
        
        XCTAssert(listManager.getStartingLists() == (listID1,listID2))
        
        listManager.setStartingList(("sb","sH"))
        
        XCTAssert(listManager.getStartingLists() == ("sb","sH"))
    }

}
