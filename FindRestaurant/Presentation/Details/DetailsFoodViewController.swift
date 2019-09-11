//
//  DetailsFoodViewController.swift
//  FindRestaurant
//
//  Created by Thiago Zagui Giacomini on 27/08/19.
//  Copyright © 2019 Thiago Zagui Giacomini. All rights reserved.
//

import UIKit
import AlamofireImage
import MapKit
import CoreLocation

class DetailsFoodViewController: UIViewController {
    
    @IBOutlet weak var detailsFoodView: DetailsFoodView?
    
    var detailsVO: DetailsVO?

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        detailsFoodView?.collectionView?.register(DetailsCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        detailsFoodView?.collectionView?.dataSource = self
        detailsFoodView?.collectionView?.delegate = self
    }
    
    func initViews() {
        if let detailsVO = detailsVO {
            detailsFoodView?.priceLabel?.text = detailsVO.price
            detailsFoodView?.hoursLabel?.text = detailsVO.isOpen
            detailsFoodView?.locationLabel?.text = detailsVO.phoneNumber
            detailsFoodView?.ratingsLabel?.text = detailsVO.rating
            detailsFoodView?.collectionView?.reloadData()
            centerMap(for: detailsVO.coordinate)
            title = detailsVO.name
        }
    }
    
    func centerMap(for coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 100, longitudinalMeters: 100)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        detailsFoodView?.mapView?.addAnnotation(annotation)
        detailsFoodView?.mapView?.setRegion(region, animated: true)
    }

}

extension DetailsFoodViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailsVO?.imageUrls.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
        
        if cell is DetailsCollectionViewCell, let url = detailsVO?.imageUrls[indexPath.item] {
            (cell as! DetailsCollectionViewCell).imageView.af_setImage(withURL: url)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // resizing images to fit on space
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        // changing page makers on bottom
        detailsFoodView?.pageControl?.currentPage = indexPath.item
    }
}
