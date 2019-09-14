//
//  LocationViewAssembler.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 14/09/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import Foundation

protocol LocationViewModule: AppComponent {
    func provides() -> LocationPresenter
}

extension LocationViewModule where Self: FeaturesComponent {
    func provides() -> LocationPresenter {
        return LocationPresenter(networkService: provides(), locationService: provides())
    }
    
    
}
