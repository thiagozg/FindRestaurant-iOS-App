//
//  LocationViewController.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 27/08/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, LocationNetworkAction {
    
    @IBOutlet weak var locationView: LocationView?
    private var appDelegate: AppDelegate?
    private var presenter: LocationPresenter?
    private var locationService: LocationService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        if appDelegate != nil {
            presenter = LocationPresenter(appDelegate!.networkService, locationNetworkAction: self)
        }
        initLocationService()
    }
    
    private func initLocationService() {
        locationService = appDelegate?.locationService
        locationView?.didTapAllow = {
            self.locationService?.requestLocationAuthorization()
        }
        
        let locationStatus = appDelegate?.locationService.status
        if locationStatus == .authorizedAlways || locationStatus == .authorizedWhenInUse {
            let nav = appDelegate?.storyboard.instantiateViewController(withIdentifier: "RestaurantNavigationController")
                as? UINavigationController
            appDelegate?.navigationController = nav
            appDelegate?.window.rootViewController = nav
            locationService?.getLocation()
            (nav?.topViewController as? RestaurantTableViewController)?.delegate = appDelegate
        }
        
        locationService?.newLocation = { [weak self] result in
            switch result {
            case .success(let location):
                self?.presenter?.loadRestaurants(with: location.coordinate)
            case .failure(let error):
                assertionFailure("Error getting the users location \(error)")
            }
        }
    }
    
    func loadRestaurantsSuccessfully(vo restaurantsVO: [RestaurantVO]) {
        if let nav = appDelegate?.window.rootViewController as? UINavigationController,
            let restaurantListViewController = nav.topViewController as? RestaurantTableViewController {
            restaurantListViewController.restaurantsVO = restaurantsVO
        } else if let nav = appDelegate?.storyboard.instantiateViewController(withIdentifier: "RestaurantNavigationController")
            as? UINavigationController {
            appDelegate?.navigationController = nav
            appDelegate?.window.rootViewController?.present(nav, animated: true) {
                let restaurantTableViewController = (nav.topViewController as? RestaurantTableViewController)
                // TODO: remove this after refact RestaurantTableViewController
                restaurantTableViewController?.delegate = self.appDelegate
                restaurantTableViewController?.restaurantsVO = restaurantsVO
            }
        }
    }

}
