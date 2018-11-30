//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Aditya Bhat on 10/21/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import UIKit
import UserNotifications

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem)
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController {

    // MARK: - Outlets

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!

    // MARK: - Delegate

    weak var delegate: ItemDetailViewControllerDelegate?

    // MARK: - Instance variables

    let dueDateCellIndexPath = IndexPath(row: 1, section: 1)
    let datePickerCellIndexPath = IndexPath(row: 2, section: 1)
    /// The `UIDatePicker` has a height of 216 by default, so using 217 here (1 extra point for the separator line)
    let datePickerCellHeight: CGFloat = 217

    var itemToEdit: ChecklistItem?
    var isDatePickerVisible = false
    var dueDate = Date() {
        didSet {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            dueDateLabel.text = formatter.string(from: dueDate)
        }
    }

    // MARK: - Lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()

        dueDate = itemToEdit?.dueDate ?? dueDate
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    // MARK: - Actions

    @IBAction func cancel() {
        delegate?.itemDetailViewControllerDidCancel(self)
    }

    @IBAction func done() {
        if let item = itemToEdit {
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotifications()
            delegate?.itemDetailViewController(self, didFinishEditing: itemToEdit!)
        } else {
            let item = ChecklistItem(text: textField.text!, isChecked: false)
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotifications()
            delegate?.itemDetailViewController(self, didFinishAdding: item)
        }
    }

    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
    }
    @IBAction func shouldRemindToggled(_ sender: UISwitch) {
        textField.resignFirstResponder()

        if sender.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound], completionHandler: { _, _ in })
        }
    }

    // MARK: - Date picker related

    private func toggleDatePicker() {
        if !isDatePickerVisible {
            showDatePicker()
        } else {
            hideDatePicker()
        }
    }

    private func showDatePicker() {
        guard !isDatePickerVisible else {
            return
        }
        isDatePickerVisible = true

        dueDateLabel.textColor = dueDateLabel.tintColor
        datePicker.setDate(dueDate, animated: false)

        // group multiple simultaneous operations
        tableView.beginUpdates()
        tableView.insertRows(at: [datePickerCellIndexPath], with: .fade)
        tableView.reloadRows(at: [dueDateCellIndexPath], with: .none)
        tableView.endUpdates()
    }

    private func hideDatePicker() {
        guard isDatePickerVisible else {
            return
        }
        isDatePickerVisible = false

        dueDateLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)

        // group multiple simultaneous operations
        tableView.beginUpdates()
        tableView.reloadRows(at: [dueDateCellIndexPath], with: .none)
        tableView.deleteRows(at: [datePickerCellIndexPath], with: .fade)
        tableView.endUpdates()
    }

    // MARK: - Table view data source
    // Dangerzone!
    // Should avoid overriding these methods when using static cells

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath == datePickerCellIndexPath else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
        return datePickerCell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == datePickerCellIndexPath.section && isDatePickerVisible else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
        return super.tableView(tableView, numberOfRowsInSection: section) + 1
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath == datePickerCellIndexPath else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
        return datePickerCellHeight
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard indexPath == dueDateCellIndexPath else {
            return nil
        }
        return indexPath
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()

        if indexPath == dueDateCellIndexPath {
            toggleDatePicker()
        }
    }

    // need this otherwise will crash at runtime since the standard static cell datasource is not updated for inserting a new cell
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath == datePickerCellIndexPath {
            // hacky way to not crash on the inserted row
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }

}

extension ItemDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)

        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
}
