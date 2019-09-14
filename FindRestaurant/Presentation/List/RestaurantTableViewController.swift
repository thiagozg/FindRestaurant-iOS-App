//
//  RestaurantTableTableViewController.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 27/08/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    
    var presenter: RestaurantTablePresenter? {
        didSet {
            presenter?.attachUI(ui: self)
        }
    }
    
    var restaurantsVO = [RestaurantVO]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantsVO.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: RestaurantTableViewControllerConstants.restaurantCell,
            for: indexPath)

        if cell is RestaurantCell {
            let restaurant = restaurantsVO[indexPath.row]
            (cell as! RestaurantCell).configure(with: restaurant)
        }
        
        return cell
    }
    
    // MARK: Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurant = restaurantsVO[indexPath.row]
        self.didTapCell(vo: restaurant)
    }

}

extension RestaurantTableViewController: IRestaurantTableViewController {    
    func didTapCell(vo restaurant: RestaurantVO) {
        self.presenter?.loadDetails(withId: restaurant.id)
    }
    
    func showDetailsViewController(vo detailsVO: DetailsVO) {
        if let detailsViewController = storyboard?.instantiateViewController(
            withIdentifier: RestaurantTableViewControllerConstants.detailsViewController)
            as? DetailsFoodViewController {
            detailsViewController.detailsVO = detailsVO
            navigationController?.pushViewController(detailsViewController, animated: true)
        }
    }
}

struct RestaurantTableViewControllerConstants {
    static let detailsViewController = "DetailsViewController"
    static let restaurantCell = "RestaurantCell"
}
