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
    var appDelegate: AppDelegate?
    var appModule: AppModule?
    private lazy var presenter: LocationPresenter? = appModule?.provides()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.attachUI(ui: self)
        handleLocationStatus()
    }
    
    private func handleLocationStatus() {
        locationView?.didTapAllow = {
            self.presenter?.requestLocationAuthorization()
        }
    }
}

extension LocationViewController: ILocationViewController {
    func showRestaurantsWithTrasition(vo restaurantsVO: [RestaurantVO]) {
        appDelegate?.changeToRestaurantNavigationController { restaurantTableViewController in
            restaurantTableViewController?.restaurantsVO = restaurantsVO
        }
    }
    
    func showRestaurants(vo restaurantsVO: [RestaurantVO]) {
        if let restaurantTableViewController = appDelegate?.navigationController?.topViewController
            as? RestaurantTableViewController {
            restaurantTableViewController.presenter = appModule?.provides()
            restaurantTableViewController.restaurantsVO = restaurantsVO
        }
    }
    
    func updateNavigationController() {
        appDelegate?.updateNavigationController(withIdentifier: NavigationConstants.restaurantNavigationController)
    }
}
