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

    let getButtonTitles = (stop: "Stop", start: "Get My Location")
    let getLocationTimeout: Double = 10

    private let locationManager = CLLocationManager()
    private var location: CLLocation?
    private var updatingLocation = false

    private var lastLocationError: Error?

    private(set) var latLongFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = latLongDecimalPlaces
        formatter.maximumFractionDigits = latLongDecimalPlaces
        return formatter
    }()

    private var statusMessage: String {
        guard location == nil else {
            return ""
        }

        if let error = lastLocationError as NSError? {
            if error.domain == kCLErrorDomain && error.code == CLError.denied.rawValue {
                return "Location Services Disabled"
            } else {
                return "Error Getting Location"
            }
        } else if !CLLocationManager.locationServicesEnabled() {
            return "Location Services Disabled"
        } else if updatingLocation {
            return "Searching..."
        } else {
            return "Tap '\(getButtonTitles.start)' to Start"
        }
    }

    private var addressMessage: String {
        guard location != nil else {
            return ""
        }
        if let place = placemark {
            return String(from: place)
        } else if performingReverseGeocoding {
            return "Searching for Address..."
        } else if lastGeocodeError != nil {
            return "Error Finding Address"
        } else {
            return "No Address Found"
        }
    }

    private let geocoder = CLGeocoder()
    private var placemark: CLPlacemark?
    private var performingReverseGeocoding = false
    private var lastGeocodeError: Error?

    private var timer: Timer?

    // MARK: - Outlets

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!

    // MARK: - Actions

    @IBAction func getLocation() {
        guard isAuthorized() else {
            return
        }

        if updatingLocation {
            stopLocationManager()
        } else {
            location = nil
            lastLocationError = nil
            placemark = nil
            lastGeocodeError = nil
            startLocationManager()
        }
        updateLabels()
    }

    // MARK: - Controller lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        updateLabels()
    }

    /// Whether the application is authorized for location services or not. Will request authorization if the user has not decided yet.
    private func isAuthorized() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .denied, .restricted:
            showLocationServicesDeniedAlert()
            return false
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return false
        case .authorizedAlways, .authorizedWhenInUse:
            return true
        }
    }

    private func startLocationManager() {
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        updatingLocation = true
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(didTimeOut), userInfo: nil, repeats: false)
    }

    private func stopLocationManager() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = nil
        updatingLocation = false
        timer?.invalidate()
    }

    @objc private func didTimeOut() {
        print("*** Time out ***")
        if location == nil {
            stopLocationManager()
            lastLocationError = NSError(domain: "MyLocationsErrorDomain", code: 1, userInfo: nil)
            updateLabels()
        }
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
        } else {
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            tagButton.isHidden = true
        }
        messageLabel.text = statusMessage
        addressLabel.text = addressMessage
        configureGetButton()
    }

    private func configureGetButton() {
        if updatingLocation {
            getButton.setTitle(getButtonTitles.stop, for: .normal)
        } else {
            getButton.setTitle(getButtonTitles.start, for: .normal)
        }
    }

    private func performReverseGeocoding(on location: CLLocation) {
        guard !performingReverseGeocoding else {
            return
        }

        print("*** Going to reverse geocode (lat/long -> address) ***")
        performingReverseGeocoding = true
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if error == nil, let places = placemarks, !places.isEmpty {
                self.placemark = places.last!
            } else {
                self.placemark = nil
            }

            self.performingReverseGeocoding = false
            self.updateLabels()
        }
    }

}

extension CurrentLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("did fail with error: \(error)")

        guard (error as NSError).code != CLError.locationUnknown.rawValue else {
            return
        }

        lastLocationError = error
        stopLocationManager()
        updateLabels()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // FIXME: streamline / simplify this method
        guard let newLocation = locations.last else {
            return
        }
        print("did update locations with: \(newLocation)")

        guard newLocation.timestamp.timeIntervalSinceNow > -5 && newLocation.horizontalAccuracy >= 0 else {
            // if the new location is too old (5 seconds here) we ignore it since it's probably a cached result
            // measurements with horizontalAccuracy < 0 are invalid
            return
        }

        let distance = location?.distance(from: newLocation) ?? CLLocationDistance(Double.greatestFiniteMagnitude)

        // larger accuracy is bad (less accurate)
        if location == nil || newLocation.horizontalAccuracy < location!.horizontalAccuracy {
            lastLocationError = nil
            location = newLocation
        }
        if newLocation.horizontalAccuracy <= locationManager.desiredAccuracy {
            print("*** We're done ***")
            if distance > 0 {
                // forces a final reverse geocoding, even if there is one currently going on
                performingReverseGeocoding = false
            }
            stopLocationManager()
        } else if distance < 1 {
            let timeinterval = newLocation.timestamp.timeIntervalSince(location!.timestamp)
            if timeinterval > getLocationTimeout {
                print("*** Force done! ***")
                stopLocationManager()
            }
        }
        updateLabels()
        performReverseGeocoding(on: newLocation)
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        getLocation()
    }

}

fileprivate extension String {
    init(from placemark: CLPlacemark) {
        self =
        """
        \(placemark.subThoroughfare?.appending(" ") ?? "")\(placemark.thoroughfare ?? "")
        \(placemark.locality?.appending(" ") ?? "")\(placemark.administrativeArea?.appending(" ") ?? "")\(placemark.postalCode ?? "")
        """
    }
}
