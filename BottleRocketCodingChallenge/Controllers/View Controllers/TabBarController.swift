//
//  TabBarController.swift
//  BottleRocketCodingChallenge
//
//  Created by Brayden Harris on 7/21/19.
//  Copyright © 2019 Brayden Harris. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Change the font of the tab bar items' titles
        guard let avenirFont = UIFont(name: "AvenirNext-Regular", size: 10) else { return }
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : avenirFont], for: .normal)
    }
}
