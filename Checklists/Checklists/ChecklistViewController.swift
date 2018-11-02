//
//  ViewController.swift
//  Checklists
//
//  Created by Aditya Bhat on 10/14/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {

    var items = [ChecklistItem]()
    let addItemSegueId = "AddItem"
    let editItemSegueId = "EditItem"

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
        self.navigationItem.leftBarButtonItem = self.editButtonItem
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
            items[indexPath.row].toggleChecked()
            configureCheckmark(for: cell, with: items[indexPath.row])
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // remove the item from the data model
        items.remove(at: indexPath.row)
        // remove the row from the table view
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case addItemSegueId:
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        case editItemSegueId:
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        default:
            break
        }
    }

    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }

    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        items.append(item)
        let indexPath = IndexPath(row: items.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)

        navigationController?.popViewController(animated: true)
    }

    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = items.firstIndex(where: {$0 == item}) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }

    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        var text: NSAttributedString
        let checkedAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.strikethroughStyle : NSUnderlineStyle.single.rawValue,
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        ]
        let checkLabel = cell.viewWithTag(1001) as! UILabel

        if item.isChecked {
            checkLabel.text = "✅"
            text = NSAttributedString(string: item.text, attributes: checkedAttributes)
        } else {
            checkLabel.text = " "
            text = NSAttributedString(string: item.text)
        }

        let cellLabel = cell.viewWithTag(1000) as! UILabel
        cellLabel.attributedText = text
    }

    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }

}
