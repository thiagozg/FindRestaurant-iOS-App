//
//  LocationViewController.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 27/08/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController {
    
    @IBOutlet weak var locationView: LocationView?
    weak var delegate: LocationActions?

    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationDelegate()
    }
    
    func initLocationDelegate() {
        locationView?.didTapAllow = {
            self.delegate?.didTapAllow()
        }
    }

}

protocol LocationActions: class {
    func didTapAllow()
}
