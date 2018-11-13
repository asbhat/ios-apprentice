//
//  Checklist.swift
//  Checklists
//
//  Created by Aditya Bhat on 11/5/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import Foundation

class Checklist: NSObject, Codable {
    var name = ""
    var items = [ChecklistItem]()

    init(name: String) {
        self.name = name
        super.init()
    }

}
