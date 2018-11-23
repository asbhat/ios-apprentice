//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Aditya Bhat on 11/8/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController {

    // MARK: Outlets

    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    
    // MARK: Delegate

    weak var delegate: ListDetailViewControllerDelegate?

    // MARK: Instance variables

    let pickIconSegueId = "PickIcon"
    var checklistToEdit: Checklist?
    var iconName = String(describing: ChecklistIcon.folder) {
        didSet {
            iconImageView.image = UIImage(named: iconName)
        }
    }

    // MARK: Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        iconName = checklistToEdit?.iconName ?? iconName
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch indexPath.section {
        case 1:
            return indexPath
        default:
            return nil
        }
    }

    // MARK: Actions

    @IBAction func cancel() {
        delegate?.listDetailViewControllerDidCancel(self)
    }

    @IBAction func done() {
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishEditing: checklist)
        } else {
            let checklist = Checklist(name: textField.text!, iconName: iconName)
            delegate?.listDetailViewController(self, didFinishAdding: checklist)
        }
    }

    // MARK: Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case pickIconSegueId:
            let controller = segue.destination as! IconPickerViewController
            controller.delegate = self
        default:
            break
        }
    }

}

// MARK: - Extensions

extension ListDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)

        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
}

extension ListDetailViewController: IconPickerViewControllerDelegate {
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        navigationController?.popViewController(animated: true)
    }
}
