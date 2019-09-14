//
//  RestaurantListPresenter.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 10/09/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import Foundation
import Moya

class RestaurantTablePresenter {
    
    private let networkService: NetworkService
    private weak var viewController: IRestaurantTableViewController?
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func attachUI(ui viewController: IRestaurantTableViewController) {
        self.viewController = viewController
    }
    
    func loadDetails(withId id: String) {
        networkService.yelpProvider.request(.details(id: id)) { [weak self] (result) in
            switch result {
                
            case .success(let response):
                guard let strongSelf = self else { return }
                if let detailsResponse = try? strongSelf.networkService.jsonDecoder.decode(
                    DetailsResponse.self, from: response.data) {
                    let detailsVO = DetailsVO(detailsResponse: detailsResponse)
                    self?.viewController?.showDetailsViewController(vo: detailsVO)
                }
                
            case .failure(let error):
                // FIXME: should show error state
                print("Failure to get Restaurant Details: \(error)")
            }
        }
    }
    
}
