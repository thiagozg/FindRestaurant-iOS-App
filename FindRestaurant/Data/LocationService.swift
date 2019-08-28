//
//  LocationService.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 27/08/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import Foundation
import CoreLocation

enum Result<T> {
    case success(T)
    case failure(Error)
}

final class LocationService: NSObject {
    
    private let manager: CLLocationManager
    
    var newLocation: ((Result<CLLocation>) -> Void)?
    var didChangeStatus: ((Bool) -> Void)?
    
    var status: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
    
    init(manager: CLLocationManager = .init()) {
        self.manager = manager
        super.init()
        manager.delegate = self
    }
    
    func requestLocationAuthorization() {
        // will callback #locationManager(didChangeAuthorization)
        manager.requestWhenInUseAuthorization()
    }
    
    func getLocation() {
        // will callback #locationManager(didUpdateLocations)
        manager.requestLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        newLocation?(.failure(error))
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.sorted(by: {$0.timestamp > $1.timestamp}).first {
            newLocation?(.success(location))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined, .restricted, .denied:
            didChangeStatus?(false)
        default:
            didChangeStatus?(true)
        }
    }
}
