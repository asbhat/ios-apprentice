//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Aditya Bhat on 10/18/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import Foundation
import UserNotifications

class ChecklistItem: NSObject, Codable {
    var text: String
    var dueDate: Date
    var shouldRemind: Bool
    private(set) var isChecked: Bool
    private(set) var itemID: Int

   init(text: String, dueDate: Date = Date(), isChecked: Bool = false, shouldRemind: Bool = false) {
        self.text = text
        self.dueDate = dueDate
        self.isChecked = isChecked
        self.shouldRemind = shouldRemind
        self.itemID = DataModel.nextChecklistItemID()
        super.init()
    }

    func toggleChecked() {
        scheduleNotifications()
        isChecked.toggle()
    }

    func scheduleNotifications() {
        removeNotification()
        guard !isChecked && shouldRemind && dueDate > Date() else {
            return
        }
        let content = UNMutableNotificationContent()
        content.title = "Reminder:"
        content.body = text
        content.sound = .default

        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.month, .day, .hour, .minute], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: String(itemID), content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }

    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [String(itemID)])
    }

    deinit {
        removeNotification()
    }
}
