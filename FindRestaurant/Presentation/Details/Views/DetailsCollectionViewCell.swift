//
//  DetailsCollectionViewCell.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 08/09/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import UIKit

@IBDesignable class DetailsCollectionViewCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
        ])
    }
}
