//
//  RestaurantsVO.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 05/09/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import Foundation

struct RestaurantVO {
    let name: String
    let imageUrl: URL
    let distance: Double
    let id: String
    
    static var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }
    
    var formattedDistance: String? {
        return RestaurantVO.numberFormatter.string(from: distance as NSNumber)
    }
}

extension RestaurantVO {
    init(business: RestaurantDTO) {
        self.name = business.name
        self.id = business.id
        self.imageUrl = business.imageUrl
        self.distance = business.distance / 1609.344
    }
}
