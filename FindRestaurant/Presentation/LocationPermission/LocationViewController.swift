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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        if appDelegate != nil {
            presenter = LocationPresenter(ui: self, appDelegate!.networkService, appDelegate!.locationService)
        }
        handleLocationStatus()
    }
    
    private func handleLocationStatus() {
        locationView?.didTapAllow = {
            self.presenter?.requestLocationAuthorization()
        }
    }
}

extension LocationViewController: ILocationViewController {
    func showRestaurants(vo restaurantsVO: [RestaurantVO]) {
        appDelegate?.changeToRestaurantNavigationController { restaurantTableViewController in
            restaurantTableViewController?.restaurantsVO = restaurantsVO
        }
    }
    
    func showRestaurantsWithTrasition(vo restaurantsVO: [RestaurantVO]) {
        if let restaurantTableViewController = appDelegate?.navigationController?.topViewController
            as? RestaurantTableViewController {
            restaurantTableViewController.restaurantsVO = restaurantsVO
        }
    }
    
    func updateNavigationController() {
        appDelegate?.updateNavigationController(withIdentifier: NavigationConstants.restaurantNavigationController)
    }
}
