//
//  LunchViewController.swift
//  BottleRocketCodingChallenge
//
//  Created by Brayden Harris on 7/19/19.
//  Copyright © 2019 Brayden Harris. All rights reserved.
//

import UIKit

class LunchViewController: UIViewController {
    // MARK: - Properties
    var restaurantMapViewIsVisible = false
    
    // MARK: - IBOutlets
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingErrorView: UIView!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var noInternetLabel: UILabel!
    @IBOutlet weak var restaurantsCollectionView: UICollectionView!
    @IBOutlet weak var restaurantMapViewContainerView: UIView!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        retryButton.layer.cornerRadius = 10
        
        fetchRestaurants()
    }
    
    // MARK: - IBActions
    @IBAction func mapViewButtonTapped(_ sender: Any) {
        guard let navBarBottom = self.navigationController?.navigationBar.safeAreaInsets.bottom else { return }
        
        if restaurantMapViewIsVisible {
            UIView.animate(withDuration: 0.5) {
                self.restaurantMapViewContainerView.frame = CGRect(x: 0, y: navBarBottom - self.view.frame.height, width: self.view.frame.width, height: self.view.frame.height)
                
                self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "icon_map")
                
                self.restaurantMapViewIsVisible = false
            }
        } else {
            UIView.animate(withDuration: 0.5) {
                self.restaurantMapViewContainerView.frame = CGRect(x: 0, y: navBarBottom, width: self.view.frame.width, height: self.view.frame.height)
                
                self.navigationItem.rightBarButtonItem?.image = #imageLiteral(resourceName: "ic_close")
                
                self.restaurantMapViewIsVisible = true
            }
        }
    }
    
    @IBAction func retryButtonTapped(_ sender: Any) {
        loadingErrorView.isHidden = true
        fetchRestaurants()
    }
    
    func fetchRestaurants() {
        RestaurantController.shared.fetchRestaurants { (restaurants, error) in
            if let error = error {
                DispatchQueue.main.async {
                    if error.code == -1009 {
                        self.loadingErrorView.isHidden = false
                    } else {
                        self.noInternetLabel.text = error.localizedDescription
                        self.loadingErrorView.isHidden = false
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                self.restaurantsCollectionView.reloadData()
                
                // Reveal the Collection View
                UIView.animate(withDuration: 0.5, animations: {
                    self.loadingView.alpha = 0
                })
                
                // Notify the mapView to update its MKPoint annotations with restaurants
                let notification = Notification(name: Notification.Name("restaurantsLoaded"))
                NotificationCenter.default.post(notification)
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let restaurantIndex = restaurantsCollectionView.indexPathsForSelectedItems?[0] else { return }
            let destinationVC = segue.destination as? RestaurantDetailsViewController
            destinationVC?.restaurant = RestaurantController.shared.restaurants[restaurantIndex.row]
        }
    }

}
// MARK: - CollectionViewDataSource and CollectionViewDelegateFlowLayout
extension LunchViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return RestaurantController.shared.restaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "restaurantCell", for: indexPath) as? RestaurantCollectionViewCell
        cell?.restaurant = RestaurantController.shared.restaurants[indexPath.row]
        
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = CGFloat(15)
        return CGSize(width: (collectionView.frame.width / 2) - spacing, height: (collectionView.frame.width / 2) - spacing)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        self.restaurantsCollectionView.collectionViewLayout.invalidateLayout()
    }
    
}

