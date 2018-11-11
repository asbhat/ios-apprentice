//
//  DataModel.swift
//  Checklists
//
//  Created by Aditya Bhat on 11/10/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]() {
        didSet {
            saveData()
        }
    }

    var documentsDirectory: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    var dataFilePath: URL {
        return documentsDirectory.appendingPathComponent("Checklists.plist")
    }

    init() {
        loadChecklists(from: dataFilePath)
    }

    // MARK: - Save to and load from disk

    func saveData() {
        saveChecklists(to: dataFilePath)
    }

    private func saveChecklists(to path: URL) {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: path, options: .atomic)
        } catch {
            print("Error encoding the items array!")
        }
    }

    private func loadChecklists(from path: URL) {
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([Checklist].self, from: data)
            } catch {
                print("Error decoding the items array!")
            }
        }
    }

}
