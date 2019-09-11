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
    private weak var viewController: ILocationViewController?
    
    init(_ networkService: NetworkService, ui viewController: ILocationViewController) {
        self.networkService = networkService
        self.viewController = viewController
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
                    strongSelf.viewController?.loadRestaurantsSuccessfully(vo: restaurantsVO ?? [])

                    
                case .failure(let error):
                    print("Failure to get Restaurants List: \(error)")
                }
        }
    }
}
