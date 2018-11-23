//
//  ChecklistIcon.swift
//  Checklists
//
//  Created by Aditya Bhat on 11/15/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import Foundation

enum ChecklistIcon: CustomStringConvertible, CaseIterable {

    case noIcon
    case appointments
    case birthdays
    case chores
    case drinks
    case folder
    case groceries
    case inbox
    case photos
    case trips

    var description: String {
        switch self {
        case .noIcon: return "No Icon"
        case .appointments: return "Appointments"
        case .birthdays: return "Birthdays"
        case .chores: return "Chores"
        case .drinks: return "Drinks"
        case .folder: return "Folder"
        case .groceries: return "Groceries"
        case .inbox: return "Inbox"
        case .photos: return "Photos"
        case .trips: return "Trips"
        }
    }
}
