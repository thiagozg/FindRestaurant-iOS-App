//
//  AppAssembler.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 14/09/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import Foundation

protocol AppComponent {
    func provides() -> NetworkService
    func provides() -> LocationService
}

protocol FeaturesComponent: LocationViewModule, RestaurantTableModule { }

class AppModule: FeaturesComponent, AppComponent {
    private lazy var networkService = NetworkService()
    private lazy var locationService = LocationService()
    
    func provides() -> NetworkService {
        return networkService
    }
    
    func provides() -> LocationService {
        return locationService
    }
}
