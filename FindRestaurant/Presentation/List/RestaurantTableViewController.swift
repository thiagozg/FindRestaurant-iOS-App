//
//  RestaurantTableTableViewController.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 27/08/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import UIKit

class RestaurantTableViewController: UITableViewController {
    
    var restaurantsVO = [RestaurantVO]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delegate: RestaurantListActions?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Table View Data Source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantsVO.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantCell", for: indexPath)

        if cell is RestaurantCell {
            let restaurant = restaurantsVO[indexPath.row]
            (cell as! RestaurantCell).configure(with: restaurant)
        }
        
        return cell
    }
    
    // MARK: Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailsViewController = storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") else { return }
        navigationController?.pushViewController(detailsViewController, animated: true)
        let restaurant = restaurantsVO[indexPath.row]
        delegate?.didTapCell(detailsViewController, vo: restaurant)
    }

}

protocol RestaurantListActions: class {
    func didTapCell(_ viewController: UIViewController, vo restaurant: RestaurantVO)
}
