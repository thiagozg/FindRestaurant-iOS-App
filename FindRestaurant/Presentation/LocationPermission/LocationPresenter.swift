//
//  LocationController.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 09/09/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import Foundation
import Moya
import CoreLocation

class LocationPresenter {
    
    private let networkService: NetworkService
    private let locationService: LocationService
    private weak var viewController: ILocationViewController?
    private lazy var locationStatus: CLAuthorizationStatus = {
        return CLAuthorizationStatus.notDetermined
    }()
    
    init(ui viewController: ILocationViewController, _ networkService: NetworkService, _ locationService: LocationService) {
        self.networkService = networkService
        self.locationService = locationService
        self.viewController = viewController
        self.locationStatus = locationService.status
        setupLocationService()
    }
    
    func setupLocationService() {
        if locationStatus == .authorizedAlways || locationStatus == .authorizedWhenInUse {
            self.viewController?.updateNavigationController()
            locationService.getLocation()
        }
        
        locationService.newLocation = { [weak self] result in
            switch result {
            case .success(let location):
                self?.loadRestaurants(with: location.coordinate)
            case .failure(let error):
                // TODO: should show error state
                assertionFailure("Error getting the user location \(error)")
            }
        }
    }
    
    func requestLocationAuthorization() {
        locationService.requestLocationAuthorization()
    }
    
    func loadRestaurants(with coordinate: CLLocationCoordinate2D) {
        networkService.yelpProvider.request(.search(
            lat: coordinate.latitude,
            long: coordinate.longitude,
            limit: 10)) { [weak self] (result) in
            
                switch result {
                
                case .success(let response):
                    guard let strongSelf = self else { return }
                    
                    let restaurantsResponse = try? strongSelf.networkService.jsonDecoder.decode(RestaurantsResponse.self, from: response.data)
                    let restaurantsVO = restaurantsResponse?.businesses
                        .compactMap(RestaurantVO.init)
                        .sorted(by: { $0.distance < $1.distance })
                    strongSelf.loadRestaurantsSuccessfully(restaurantsVO ?? [])

                    
                case .failure(let error):
                    print("Failure to get Restaurants List: \(error)")
                }
        }
    }
    
    private func loadRestaurantsSuccessfully(_ restaurantsVO: [RestaurantVO]) {
        if !hasLocationAuthorized(locationStatus) {
            viewController?.showRestaurants(vo: restaurantsVO)
        } else {
            viewController?.showRestaurantsWithTrasition(vo: restaurantsVO)
        }
    }
    
    private func hasLocationAuthorized(_ locationStatus: CLAuthorizationStatus) -> Bool {
        return locationStatus == .authorizedAlways || locationStatus == .authorizedWhenInUse
    }
    
}
