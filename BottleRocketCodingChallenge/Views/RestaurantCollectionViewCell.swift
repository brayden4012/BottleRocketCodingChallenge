//
//  RestaurantCollectionViewCell.swift
//  BottleRocketCodingChallenge
//
//  Created by Brayden Harris on 7/20/19.
//  Copyright © 2019 Brayden Harris. All rights reserved.
//

import UIKit

class RestaurantCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    var restaurant: Restaurant? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        nameLabel.adjustsFontSizeToFitWidth = true
        categoryLabel.adjustsFontSizeToFitWidth = true
    }
    
    func updateViews() {
        guard let restaurant = restaurant else { return }
        
        DispatchQueue.main.async {
            self.backgroundImageView.image = restaurant.backgroundImage
            self.nameLabel.text = restaurant.name
            self.categoryLabel.text = restaurant.category
        }
    }
}
