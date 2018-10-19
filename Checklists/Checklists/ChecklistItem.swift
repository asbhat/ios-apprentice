//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Aditya Bhat on 10/18/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import Foundation

class ChecklistItem {
    var text = ""
    private(set) var isChecked = false

    init(text: String, isChecked: Bool) {
        self.text = text
        self.isChecked = isChecked
    }

    func toggleChecked() {
        isChecked.toggle()
    }
}
