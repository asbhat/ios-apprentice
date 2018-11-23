//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Aditya Bhat on 10/18/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, Codable {
    var text: String
    private(set) var isChecked: Bool

    init(text: String, isChecked: Bool = false) {
        self.text = text
        self.isChecked = isChecked
        super.init()
    }

    func toggleChecked() {
        isChecked.toggle()
    }
}
