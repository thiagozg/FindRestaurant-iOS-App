//
//  DetailsVO.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 05/09/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import Foundation
import CoreLocation

struct DetailsVO {
    let name: String
    let price: String
    let isOpen: String
    let phoneNumber: String
    let rating: String
    let imageUrls: [URL]
    let coordinate: CLLocationCoordinate2D
}

extension DetailsVO {
    init(detailsResponse: DetailsResponse) {
        self.name = detailsResponse.name
        self.price = detailsResponse.price
        self.isOpen = detailsResponse.isClosed ? "Closed" : "Open"
        self.phoneNumber = detailsResponse.phone
        self.rating = "\(detailsResponse.rating) / 5.0"
        self.imageUrls = detailsResponse.photos
        self.coordinate = detailsResponse.coordinates
    }
}
