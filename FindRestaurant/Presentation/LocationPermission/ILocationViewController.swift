//
//  ILocationViewController.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 10/09/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import Foundation

protocol ILocationViewController: class {
    func showRestaurants(vo restaurantsVO: [RestaurantVO])
    func showRestaurantsWithTrasition(vo restaurantsVO: [RestaurantVO])
    func updateNavigationController()
}
