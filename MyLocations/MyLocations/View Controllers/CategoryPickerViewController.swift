//
//  CategoryPickerViewController.swift
//  MyLocations
//
//  Created by Aditya Bhat on 12/16/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import UIKit

class CategoryPickerViewController: UITableViewController {

    // MARK: - Instance variables

    let unwindPickedCategorySegueId = "PickedCategory"
    let categoryCellIdentifier = "CategoryCell"
    let categories = Category.allCases
    private let categoryToIndex = Dictionary(uniqueKeysWithValues: Category.allCases.enumerated().map { (index, category) in return (category, index) } )

    var selectedCategory = Category.noCategory

    var selectedIndexPath: IndexPath {
        return IndexPath(row: categoryToIndex[selectedCategory]!, section: 0)
    }

    // MARK: - Controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellIdentifier, for: indexPath)

        cell.textLabel?.text = String(describing: categories[indexPath.row])
        if indexPath == selectedIndexPath {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard indexPath != selectedIndexPath else {
            return indexPath
        }

        if let newCell = tableView.cellForRow(at: indexPath) {
            newCell.accessoryType = .checkmark
        }
        if let oldCell = tableView.cellForRow(at: selectedIndexPath) {
            oldCell.accessoryType = .none
        }

        selectedCategory = categories[indexPath.row]
        return indexPath
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case unwindPickedCategorySegueId:
            break
        default:
            break
        }
    }

}
