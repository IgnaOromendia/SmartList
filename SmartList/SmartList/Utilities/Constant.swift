//
//  Constant.swift
//  SmartList
//
//  Created by Igna on 05/12/2022.
//

import Foundation

// Alias

typealias StartingLists = (buyList: String, homeList: String)

// Types

enum ListType {
    case Buy
    case Home
}

enum SortTypes {
    case none
    case name
    case price
    case amount
}

// Errors

enum ListErrors: LocalizedError {
    case alreadyAdded
    case NonExistingList
    case NonExistingProduct
}

// Cell ID

let buyListCellid = "BuyListCellid"
