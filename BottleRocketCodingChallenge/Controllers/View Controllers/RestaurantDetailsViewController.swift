//
//  RestaurantDetailsViewController.swift
//  BottleRocketCodingChallenge
//
//  Created by Brayden Harris on 7/20/19.
//  Copyright © 2019 Brayden Harris. All rights reserved.
//

import UIKit
import MapKit

class RestaurantDetailsViewController: UIViewController {

    // MARK: - Properties
    var restaurant: Restaurant? {
        didSet {
            self.loadViewIfNeeded()
            updateViews()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var twitterLabel: UILabel!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func updateViews() {
        guard let restaurant = restaurant else { return }
        
        guard let lat = CLLocationDegrees(exactly: restaurant.lat),
            let long = CLLocationDegrees(exactly: restaurant.long) else { return }
        
        DispatchQueue.main.async {
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let annotation = MKPointAnnotation()
            annotation.title = restaurant.name
            annotation.coordinate = coordinate
            self.locationMapView.setRegion(MKCoordinateRegion(center: coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000), animated: false)
            self.locationMapView.showAnnotations([annotation], animated: true)
            self.nameLabel.text = restaurant.name
            self.categoryLabel.text = restaurant.category
            self.addressLabel.text = "\(restaurant.formattedAddress[0])\n\(restaurant.formattedAddress[1])"
            self.phoneNumberLabel.text = restaurant.formattedPhone
            if let twitter = restaurant.twitter {
                self.twitterLabel.text = "@\(twitter)"
            } else {
                self.twitterLabel.text = ""
            }
        }
    }
}
