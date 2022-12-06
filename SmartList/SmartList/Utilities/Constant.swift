//
//  Constant.swift
//  SmartList
//
//  Created by Igna on 05/12/2022.
//

import Foundation

typealias ListData = (list: Dictionary<String,Product>, price: Int)

enum ListType {
    case Buy
    case Home
}

enum ListErrors: LocalizedError {
    case alreadyAdded
    case NonExistingList
    case NonExistingProduct
}
