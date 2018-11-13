//
//  ViewController.swift
//  Checklists
//
//  Created by Aditya Bhat on 10/14/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {

    let addItemSegueId = "AddItem"
    let editItemSegueId = "EditItem"
    var checklist: Checklist!

    override func viewDidLoad() {
        super.viewDidLoad()
        // self.navigationItem.leftBarButtonItem = self.editButtonItem
        title = checklist.name
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let checklistItemId = "ChecklistItem"
        let cell = tableView.dequeueReusableCell(withIdentifier: checklistItemId, for: indexPath)
        let item = checklist.items[indexPath.row]

        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            checklist.items[indexPath.row].toggleChecked()
            configureCheckmark(for: cell, with: checklist.items[indexPath.row])
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // remove the item from the data model
        checklist.items.remove(at: indexPath.row)
        // remove the row from the table view
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }

    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */

    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case addItemSegueId:
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        case editItemSegueId:
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        default:
            break
        }
    }

    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }

    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        checklist.items.append(item)
        let indexPath = IndexPath(row: checklist.items.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)

        navigationController?.popViewController(animated: true)
    }

    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.firstIndex(of: item) {
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
