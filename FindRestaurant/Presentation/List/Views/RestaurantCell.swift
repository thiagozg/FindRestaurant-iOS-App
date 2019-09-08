//
//  TableViewCell.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 27/08/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import UIKit
import AlamofireImage

class RestaurantCell: UITableViewCell {
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var makerImageView: UIImageView?
    @IBOutlet weak var restaurantNameLabel: UILabel?
    @IBOutlet weak var locationLabel: UILabel?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with restaurantsVO: RestaurantVO) {
        restaurantImageView.af_setImage(withURL: restaurantsVO.imageUrl)
        restaurantNameLabel?.text = restaurantsVO.name
        locationLabel?.text = restaurantsVO.formattedDistance
    }

}
