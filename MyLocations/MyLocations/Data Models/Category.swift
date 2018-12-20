//
//  Category.swift
//  MyLocations
//
//  Created by Aditya Bhat on 12/16/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import Foundation

enum Category: String, CustomStringConvertible, CaseIterable {
    case noCategory
    case appleStore
    case bar
    case bookstore
    case club
    case groceryStore
    case historicBuilding
    case house
    case icecreamVendor
    case landmark
    case park

    var description: String {
        return self.rawValue.propercased
    }
}

fileprivate extension String {
    var propercased: String {
        return self.replacingOccurrences(of: "([0-9A-Z])", with: " $1", options: .regularExpression, range: self.range(of: self)).trimmingCharacters(in: .whitespacesAndNewlines).capitalized
    }
}
