//
//  ViewController.swift
//  Checklists
//
//  Created by Aditya Bhat on 10/14/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

    var items = [ChecklistItem]()

    required init?(coder aDecoder: NSCoder) {
        let row0item = ChecklistItem(text: "Walk the dog", isChecked: false)
        let row1item = ChecklistItem(text: "Brush my teeth", isChecked: false)
        let row2item = ChecklistItem(text: "Learn iOS development", isChecked: false)
        let row3item = ChecklistItem(text: "Soccer practice", isChecked: false)
        let row4item = ChecklistItem(text: "Eat ice cream", isChecked: false)
        let row5item = ChecklistItem(text: "Go for a run", isChecked: false)
        let row6item = ChecklistItem(text: "Don't worry, be happy!", isChecked: false)
        items.append(contentsOf: [row0item, row1item, row2item, row3item, row4item, row5item, row6item])

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let checklistItemId = "ChecklistItem"
        let cell = tableView.dequeueReusableCell(withIdentifier: checklistItemId, for: indexPath)
        let item = items[indexPath.row]

        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        cell.accessoryType = item.isChecked ? .checkmark : .none
    }

    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }

}

