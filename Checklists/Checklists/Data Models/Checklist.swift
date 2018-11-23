//
//  Checklist.swift
//  Checklists
//
//  Created by Aditya Bhat on 11/5/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import Foundation

class Checklist: NSObject, Codable {
    var name: String
    var iconName: String
    var items = [ChecklistItem]()

    /**
     * Remaining number of unchecked items.
     *
     * O(n) complexity.
     */
    var countUncheckedItems: Int {
        return items.reduce(0) { cnt, item in cnt + (item.isChecked ? 0 : 1) }
    }

    init(name: String = "List", iconName: String = String(describing: ChecklistIcon.folder)) {
        self.name = name
        self.iconName = iconName
        super.init()
    }

}
