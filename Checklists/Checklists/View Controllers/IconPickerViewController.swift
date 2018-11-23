//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Aditya Bhat on 11/15/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import UIKit

protocol IconPickerViewControllerDelegate: class {
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {

    let iconCellId = "IconCell"
    let icons = ChecklistIcon.allCases.map {String(describing: $0)}

    // MARK: - delegate

    weak var delegate: IconPickerViewControllerDelegate?

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: iconCellId, for: indexPath)

        let iconName = icons[indexPath.row]
        cell.textLabel!.text = iconName
        cell.imageView!.image = UIImage(named: iconName)

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.iconPicker(self, didPick: icons[indexPath.row])
    }

}
