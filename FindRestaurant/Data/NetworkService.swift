//
//  NetworkService.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 01/09/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import Foundation
import Moya
import Keys

enum YelpApi {
    
    enum BusinessProvider: TargetType {
        
        case search(lat: Double, long: Double, limit: Int)
        case details(id: String)
        
        var baseURL: URL {
            return URL(string: "https://api.yelp.com/v3/businesses")!
        }
        
        var path: String {
            switch self {
            case .search:
                return "/search"
            case let .details(id):
                return "/\(id)"
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
            case let .search(lat, long, limit):
                return .requestParameters(parameters: [
                    "latitude": lat,
                    "longitude": long,
                    "limit": limit
                ], encoding: URLEncoding.queryString)
                
            case .details:
                return .requestPlain
            }
        }
        
        var headers: [String : String]? {
            // MARK: You must set Yelp Api Key on your environment take a look on: https://www.yelp.com/developers
            // and then set your key with CocoaPods Key: https://www.lordcodes.com/posts/managing-secrets-within-an-ios-app
            let keys = FindRestaurantKeys()
            return ["Authorization": "Bearer \(keys.yelpApiKey)"]
        }
        
    }
    
}
