//
//  DataModel.swift
//  Checklists
//
//  Created by Aditya Bhat on 11/10/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import Foundation

class DataModel {

    let userDefaultsChecklistIndexKey = "ChecklistIndex"
    let userDefaultsFirstTimeKey = "FirstTime"

    /// The index of the last checklist the user selected. Is `-1` if no checklist was selected.
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: userDefaultsChecklistIndexKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: userDefaultsChecklistIndexKey)
        }
    }

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
        registerDefaults()
        handleFirstTime()
    }

    private func handleFirstTime() {
        let userDefaults = UserDefaults.standard

        if userDefaults.bool(forKey: userDefaultsFirstTimeKey) {
            let checklist = Checklist()
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: userDefaultsFirstTimeKey)
            userDefaults.synchronize()
        }
    }

    func sortChecklists() {
        lists.sort(by: {checklist1, checklist2 in return checklist1.name.localizedStandardCompare(checklist2.name) == .orderedAscending})
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
                sortChecklists()
            } catch {
                print("Error decoding the items array!")
            }
        }
    }

    private func registerDefaults() {
        let defaults: [String : Any] = [
            userDefaultsChecklistIndexKey: -1,
            userDefaultsFirstTimeKey: true
        ]

        UserDefaults.standard.register(defaults: defaults)
    }
}
