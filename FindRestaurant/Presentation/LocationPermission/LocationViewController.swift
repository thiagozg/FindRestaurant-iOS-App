//
//  LocationViewController.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 27/08/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController {
    
    @IBOutlet weak var locationView: LocationView?
    private var appDelegate: AppDelegate?
    private var presenter: LocationPresenter?
    // TODO: move this logic of LocationService to Presenter
    private var locationService: LocationService?
    private var oldLocationStatus: CLAuthorizationStatus = .notDetermined
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        if appDelegate != nil {
            presenter = LocationPresenter(appDelegate!.networkService, ui: self)
        }
        initLocationService()
    }
    
    private func initLocationService() {
        self.locationService = appDelegate?.locationService
        locationView?.didTapAllow = {
            self.locationService?.requestLocationAuthorization()
        }
        
        if let locationStatus = appDelegate?.locationService.status {
            oldLocationStatus = locationStatus
            if locationStatus == .authorizedAlways || locationStatus == .authorizedWhenInUse {
                appDelegate?.updateNavigationController(withIdentifier: NavigationConstants.restaurantNavigationController)
                locationService?.getLocation()
            }
        }
        
        locationService?.newLocation = { [weak self] result in
            switch result {
            case .success(let location):
                self?.presenter?.loadRestaurants(with: location.coordinate)
            case .failure(let error):
                // TODO: should show error state
                assertionFailure("Error getting the user location \(error)")
            }
        }
    }
    
    private func hasLocationAuthorized(_ locationStatus: CLAuthorizationStatus) -> Bool {
        return locationStatus == .authorizedAlways || locationStatus == .authorizedWhenInUse
    }
}

extension LocationViewController: ILocationViewController {
    func loadRestaurantsSuccessfully(vo restaurantsVO: [RestaurantVO]) {
        if !hasLocationAuthorized(oldLocationStatus) {
            appDelegate?.changeToRestaurantNavigationController { restaurantTableViewController in
                restaurantTableViewController?.restaurantsVO = restaurantsVO
            }
        } else if let restaurantTableViewController = appDelegate?.navigationController?.topViewController
            as? RestaurantTableViewController {
            restaurantTableViewController.restaurantsVO = restaurantsVO
        }
    }
}
