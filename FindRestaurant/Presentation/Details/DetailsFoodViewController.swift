//
//  DetailsFoodViewController.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 27/08/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import UIKit

class DetailsFoodViewController: UIViewController {
    
    @IBOutlet weak var detailsFoodView: DetailsFoodView?
    
    var detailsVO: DetailsVO? {
        didSet {
            initViews()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func initViews() {
        if let detailsVO = detailsVO{
            detailsFoodView?.priceLabel?.text = detailsVO.price
            detailsFoodView?.hoursLabel?.text = detailsVO.isOpen
            detailsFoodView?.locationLabel?.text = detailsVO.phoneNumber
            detailsFoodView?.ratingsLabel?.text = detailsVO.rating
        }
    }

}
