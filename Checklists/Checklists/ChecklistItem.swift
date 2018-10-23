//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Aditya Bhat on 10/18/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import Foundation

struct ChecklistItem {
    var text = ""
    private(set) var isChecked = false

    mutating func toggleChecked() {
        isChecked.toggle()
    }
}
