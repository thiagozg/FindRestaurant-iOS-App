//
//  Models.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 05/09/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import Foundation

struct Root: Codable {
    let businesses: [RestaurantsResponse]
}

struct RestaurantsResponse: Codable {
    let id: String
    let name: String
    let imageUrl: URL
    let distance: Double
}
