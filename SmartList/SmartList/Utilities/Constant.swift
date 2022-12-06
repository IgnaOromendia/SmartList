//
//  Constant.swift
//  SmartList
//
//  Created by Igna on 05/12/2022.
//

import Foundation

enum ListType {
    case Buy
    case Home
}

enum ListErrors: LocalizedError {
    case alreadyAdded
    case NonExistingList
    case NonExistingProduct
}
