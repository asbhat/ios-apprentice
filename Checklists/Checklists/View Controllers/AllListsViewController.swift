//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Aditya Bhat on 11/4/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController {

    let showChecklistSegueId = "ShowChecklist"
    let addChecklistSegueId = "AddChecklist"
    let editChecklistSegueId = "EditChecklist"
    let listDetailViewControllerId = "ListDetailViewController"

    var dataModel = DataModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    // using view*Did*Appear so this always gets called after navigationController(_:willShow:animated:), except on the initial load
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self

        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            performSegue(withIdentifier: showChecklistSegueId, sender: dataModel.lists[index])
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        performSegue(withIdentifier: showChecklistSegueId, sender: dataModel.lists[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        cell.textLabel!.text = dataModel.lists[indexPath.row].name
        cell.accessoryType = .detailDisclosureButton
        return cell
    }

    private func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            dataModel.lists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .insert:
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            break
        case .none:
            break
        }
    }

    // Loading the List Detail controller by hand (not using a segue)
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withIdentifier: listDetailViewControllerId) as! ListDetailViewController
        controller.delegate = self

        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist

        navigationController?.pushViewController(controller, animated: true)
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case showChecklistSegueId:
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = (sender as! Checklist)
        case addChecklistSegueId:
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        case editChecklistSegueId:
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.checklistToEdit = dataModel.lists[indexPath.row]
            }
        default:
            break
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension AllListsViewController: ListDetailViewControllerDelegate {

    // MARK: - List detail delegates

    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }

    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
        let indexPath = IndexPath(row: dataModel.lists.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)

        navigationController?.popViewController(animated: true)
    }

    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let index = dataModel.lists.firstIndex(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel?.text = checklist.name
            }
        }

        navigationController?.popViewController(animated: true)
    }
}

extension AllListsViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // if the user navigates back to the parent view controller (this one), remove the saved checklist index
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
}
