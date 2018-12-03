//
//  CurrentLocationViewController.swift
//  MyLocations
//
//  Created by Aditya Bhat on 12/1/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import CoreLocation
import UIKit

class CurrentLocationViewController: UIViewController {

    // MARK: - Class / static variables

    static let latLongDecimalPlaces = 8

    // MARK: - Instance variables

    let locationManager = CLLocationManager()
    var location: CLLocation?
    var latLongFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = latLongDecimalPlaces
        formatter.maximumFractionDigits = latLongDecimalPlaces
        return formatter
    }()

    // MARK: - Outlets

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!

    // MARK: - Actions

    @IBAction func getLocation() {
        let authStatus = CLLocationManager.authorizationStatus()

        switch authStatus {
        case .denied, .restricted:
            showLocationServicesDeniedAlert()
            return
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        default:
            break
        }

        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
    }

    // MARK: - Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        updateLabels()
    }

    private func showLocationServicesDeniedAlert() {
        let alertTitle = "Location Services Disabled"
        let alertMessage = "Please enable location services for this app in Settings."

        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }

    private func updateLabels() {
        if let loc = location {
            latitudeLabel.text = latLongFormatter.string(from: NSNumber(value: loc.coordinate.latitude))
            longitudeLabel.text = latLongFormatter.string(from: NSNumber(value: loc.coordinate.longitude))
            tagButton.isHidden = false
            messageLabel.text = ""
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.isHidden = true
            messageLabel.text = "Tap '\(getButton.titleLabel?.text ?? "Get Location")' to Start"
        }
    }

}

extension CurrentLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("did fail with error: \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print("did update locations with: \(newLocation)")
        location = newLocation
        updateLabels()
    }
}
