//
//  NetworkService.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 01/09/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import Foundation
import Moya

enum YelpApi {
    
    enum BusinessProvider: TargetType {
        
        case search(lat: Double, long: Double)
        
        var baseURL: URL {
            return URL(string: "https://api.yelp.com/v3/businesses")!
        }
        
        var path: String {
            switch self {
            case .search:
                return "/search"
            }
        }
        
        var method: Moya.Method {
            return .get
        }
        
        var sampleData: Data {
            return Data()
        }
        
        var task: Task {
            switch self {
            case let .search(lat, long):
                return .requestParameters(parameters: [
                    "latitude": lat,
                    "longitude": long,
                    "limit": 1
                ], encoding: URLEncoding.queryString)
            }
        }
        
        var headers: [String : String]? {
            guard let yelpApiKey = ProcessInfo.processInfo.environment["YELP_API_KEY"] else {
                fatalError("You must set Yelp Api Key on your environment\ntake a look on: https://www.yelp.com/developers")
            }
            return ["Authorization": "Bearer \(yelpApiKey)"]
        }
        
    }
    
}
