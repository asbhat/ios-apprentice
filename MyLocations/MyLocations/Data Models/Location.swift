//
//  Location.swift
//  MyLocations
//
//  Created by Aditya Bhat on 12/9/18.
//  Copyright © 2018 Aditya Bhat. All rights reserved.
//

import CoreLocation
import Foundation

struct Location {

    // MARK: - Instance variables

    var address: CLPlacemark?
    var category: Category
    var date: Date
    var description: String?
    var coordinate: CLLocationCoordinate2D

}
