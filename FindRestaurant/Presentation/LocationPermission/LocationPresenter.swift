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
    
    let networkService: NetworkService
    let delegate: LocationNetworkAction
    
    init(_ networkService: NetworkService, locationNetworkAction delegate: LocationNetworkAction) {
        self.networkService = networkService
        self.delegate = delegate
    }
    
    func loadRestaurants(with coordinate: CLLocationCoordinate2D) {
        // using weak self to desalocating the memory like on self.jsonDecoder
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
                   strongSelf.delegate.loadRestaurantsSuccessfully(vo: restaurantsVO ?? [])

                    
                case .failure(let error):
                    print("Failure to get Restaurants List: \(error)")
                }
        }
    }
}

protocol LocationNetworkAction: class {
    func loadRestaurantsSuccessfully(vo restaurantsVO: [RestaurantVO])
}
