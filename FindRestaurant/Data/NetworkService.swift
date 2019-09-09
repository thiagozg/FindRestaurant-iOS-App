//
//  NetworkService.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 01/09/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import Foundation
import Moya

class NetworkService {
    
    let jsonDecoder = JSONDecoder()
    let yelpProvider = MoyaProvider<YelpApi.BusinessProvider>(plugins: [NetworkLoggerPlugin()])
    
    init() {
        // because on json contract is using snake_case, like param: "image_url"
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
}
