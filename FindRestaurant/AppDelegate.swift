//
//  AppDelegate.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 25/07/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import UIKit
import Moya
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow()
    let locationService = LocationService()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let service = MoyaProvider<YelpApi.BusinessProvider>(plugins: [NetworkLoggerPlugin()])
    let jsonDecoder = JSONDecoder()
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // because on json contract is using snake_case, like param: "image_url"
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        initLocationClosures()
        
        // TODO: move to LocationViewController
        switch locationService.status {
        
        case .notDetermined, .denied, .restricted:
            let locationViewController = storyboard
                .instantiateViewController(withIdentifier: "LocationViewController")
            as? LocationViewController
            // injecting locationService
            locationViewController?.delegate = self
            window.rootViewController = locationViewController
        
        default:
            let nav = storyboard.instantiateViewController(withIdentifier: "RestaurantNavigationController") as? UINavigationController
            self.navigationController = nav
            window.rootViewController = nav
            locationService.getLocation()
            (nav?.topViewController as? RestaurantTableViewController)?.delegate = self
        }
        window.makeKeyAndVisible()
        
        return true
    }
    
    private func initLocationClosures() {
        locationService.didChangeStatus = { [weak self] success in
            if success {
                self?.locationService.getLocation()
            }
        }
        
        locationService.newLocation = { [weak self] result in
            switch result {
            case .success(let location):
                // TODO: move to LocationViewController
                self?.loadRestaurants(with: location.coordinate)
            case .failure(let error):
                assertionFailure("Error getting the users location \(error)")
            }
        }
    }
    
    private func loadRestaurants(with coordinate: CLLocationCoordinate2D) {
        // MARK: for testing purpose use lat: 42.155258, long: -72.600060
        // using weak self to desalocating the memory like on self.jsonDecoder
        service.request(.search(lat: coordinate.latitude, long: coordinate.longitude, limit: 10)) { [weak self] (result) in
            switch result {
            
            case .success(let response):
                guard let strongSelf = self else { return }
                
                let root = try? strongSelf.jsonDecoder.decode(RestaurantsResponse.self, from: response.data)
                let restaurantsVO = root?.businesses
                    .compactMap(RestaurantVO.init)
                    .sorted(by: { $0.distance < $1.distance })
                
                if let nav = strongSelf.window.rootViewController as? UINavigationController,
                    let restaurantListViewController = nav.topViewController as? RestaurantTableViewController {
                    restaurantListViewController.restaurantsVO = restaurantsVO ?? []
                }
                
            case .failure(let error):
                print("Failure to get Restaurants List: \(error)")
            }
        }
    }
    
    private func loadDetails(withId id: String) {
        // TODO: move to RestaurantTableViewController
        service.request(.details(id: id)) { [weak self] (result) in
            switch result {
            
            case .success(let response):
                guard let strongSelf = self else { return }
                if let detailsResponse = try? strongSelf.jsonDecoder.decode(DetailsResponse.self, from: response.data) {
                    let detailsVO = DetailsVO(detailsResponse: detailsResponse)
                    (strongSelf.navigationController?.topViewController as? DetailsFoodViewController)?.detailsVO = detailsVO
                }
                
            case .failure(let error):
                print("Failure to get Restaurant Details: \(error)")
            }
        }
    }

}

extension AppDelegate: LocationActions, RestaurantListActions {
    func didTapAllow() {
        locationService.requestLocationAuthorization()
    }

    func didTapCell(_ restaurant: RestaurantVO) {
        loadDetails(withId: restaurant.id)
    }
}

