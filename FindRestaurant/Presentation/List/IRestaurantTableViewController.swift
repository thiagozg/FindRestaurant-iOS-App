//
//  IRestaurantTableViewController.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 10/09/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import UIKit

protocol IRestaurantTableViewController: class {
    func didTapCell(vo restaurant: RestaurantVO)
    func showDetailsViewController(vo detailsVO: DetailsVO)
}
