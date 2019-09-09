//
//  AppDelegate.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 25/07/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let networkService = NetworkService()
    let locationService = LocationService()
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        initLocationClosures()
        initStoryboard()
        window.makeKeyAndVisible()
        
        return true
    }
    
    private func initLocationClosures() {
        locationService.didChangeStatus = { [weak self] success in
            if success {
                self?.locationService.getLocation()
            }
        }
    }
    
    private func initStoryboard() {
        let locationViewController = storyboard.instantiateViewController(
            withIdentifier: "LocationViewController") as? LocationViewController
        window.rootViewController = locationViewController
    }
    
    private func loadDetails(for viewController: UIViewController, withId id: String) {
        // TODO: move to RestaurantTableViewController
        networkService.yelpProvider.request(.details(id: id)) { [weak self] (result) in
            switch result {
            
            case .success(let response):
                guard let strongSelf = self else { return }
                if let detailsResponse = try? strongSelf.networkService.jsonDecoder.decode(
                    DetailsResponse.self, from: response.data) {
                    let detailsVO = DetailsVO(detailsResponse: detailsResponse)
                    (strongSelf.navigationController?.topViewController as? DetailsFoodViewController)?.detailsVO = detailsVO
                }
                
            case .failure(let error):
                print("Failure to get Restaurant Details: \(error)")
            }
        }
    }

}

extension AppDelegate: RestaurantListActions {
    func didTapCell(_ viewController: UIViewController, vo restaurant: RestaurantVO) {
        loadDetails(for: viewController, withId: restaurant.id)
    }
}

