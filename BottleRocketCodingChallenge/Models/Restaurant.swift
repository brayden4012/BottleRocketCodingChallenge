//
//  Restaurant.swift
//  BottleRocketCodingChallenge
//
//  Created by Brayden Harris on 7/19/19.
//  Copyright © 2019 Brayden Harris. All rights reserved.
//

import UIKit

class Restaurant {
    // MARK: - Properties
    let name: String
    let backgroundImage: UIImage
    let category: String
    let formattedPhone: String?
    let twitter: String?
    let formattedAddress: [String]
    let lat: Double
    let long: Double
    
    // MARK: - Initializers
    init(name: String, backgroundImage: UIImage, category: String, formattedPhone: String?, twitter: String?, formattedAddress: [String], lat: Double, long: Double) {
        self.name = name
        self.backgroundImage = backgroundImage
        self.category = category
        self.formattedPhone = formattedPhone
        self.twitter = twitter
        self.formattedAddress = formattedAddress
        self.lat = lat
        self.long = long
    }
}
