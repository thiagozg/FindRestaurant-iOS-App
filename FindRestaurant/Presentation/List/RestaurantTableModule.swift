//
//  RestaurantListAssembler.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 14/09/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import Foundation

protocol RestaurantTableModule: AppComponent {
    func provides() -> RestaurantTablePresenter
}

extension RestaurantTableModule where Self: FeaturesComponent {
    func provides() -> RestaurantTablePresenter {
        return RestaurantTablePresenter(networkService: provides())
    }
}
