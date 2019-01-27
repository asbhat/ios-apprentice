//
//  TagLocationViewController.swift
//  MyLocations
//
//  Created by Aditya Bhat on 12/9/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import UIKit

protocol TagLocationViewControllerDelegate: class {
    func tagLocationViewControllerDidCancel(_ controller: LocationDetailsViewController)
    func tagLocationViewController(_ controller: LocationDetailsViewController, didFinishAdding location: Location)
}

class LocationDetailsViewController: UITableViewController {

    // MARK: - Outlets

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    // MARK: - Instance variables

    let pickCategorySegueId = "PickCategory"
    weak var delegate: TagLocationViewControllerDelegate?
    var location: Location!

    // TODO: have this formatting logic shared somewhere?
    private(set) var latLongFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = CurrentLocationViewController.latLongDecimalPlaces
        formatter.maximumFractionDigits = CurrentLocationViewController.latLongDecimalPlaces
        return formatter
    }()

    private(set) var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    // MARK: - Controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        if location != nil {
            updateLabels()
        }
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGestureRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath) is DescriptionTableViewCell {
            descriptionTextView.becomeFirstResponder()
        } else {
            descriptionTextView.resignFirstResponder()
        }
    }

    // MARK: - Actions

    @IBAction func cancel() {
        delegate?.tagLocationViewControllerDidCancel(self)
    }

    @IBAction func done() {
        // TODO: find the top controller more dynamically (currently assumes the tab bar is on top)
        //      want the highest-level view so a user can't touch the navigation controls or tab bar until the animation is done
        let hudView = HUDView(in: tabBarController!.view, animated: true)
        hudView.text = "Tagged"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.delegate?.tagLocationViewController(self, didFinishAdding: self.location)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            hudView.hide()
        }
    }

    @IBAction func categoryPickerDidPickCategory(_ segue: UIStoryboardSegue) {
        let controller = segue.source as! CategoryPickerViewController
        location.category = controller.selectedCategory
        updateLabels()
    }

    // MARK: - Private methods

    private func updateLabels() {
        descriptionTextView.text = location.description
        categoryLabel.text = String(describing: location.category)
        latitudeLabel.text = latLongFormatter.string(from: NSNumber(value: location.coordinate.latitude))
        longitudeLabel.text = latLongFormatter.string(from: NSNumber(value: location.coordinate.longitude))
        addressLabel.text = String(from: location.address)
        dateLabel.text = dateFormatter.string(from: location.date)
    }

    @objc private func hideKeyboard(_ gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        if indexPath == nil || !(tableView.cellForRow(at: indexPath!) is DescriptionTableViewCell) {
            descriptionTextView.resignFirstResponder()
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case pickCategorySegueId:
            let controller = segue.destination as! CategoryPickerViewController
            controller.selectedCategory = location.category
        default:
            break
        }
    }

}
