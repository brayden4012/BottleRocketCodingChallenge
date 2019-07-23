//
//  RestaurantsMapViewController.swift
//  BottleRocketCodingChallenge
//
//  Created by Brayden Harris on 7/21/19.
//  Copyright © 2019 Brayden Harris. All rights reserved.
//

import UIKit
import MapKit

class RestaurantsMapViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var restaurantsMapView: MKMapView!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(loadRestaurants), name: NSNotification.Name("restaurantsLoaded"), object: nil)
    }
    
    // MARK: - Action Methods
    @objc func loadRestaurants() {
        var annotations: [MKAnnotation] = []

        for restaurant in RestaurantController.shared.restaurants {
            guard let lat = CLLocationDegrees(exactly: restaurant.lat),
                let long = CLLocationDegrees(exactly: restaurant.long) else { return }
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let annotation = MKPointAnnotation()
            annotation.title = restaurant.name
            annotation.coordinate = coordinate
            annotations.append(annotation)
        }
        
        restaurantsMapView.showAnnotations(annotations, animated: true)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("restaurantsLoaded"), object: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRestaurantDetails" {
            guard let destinationVC = segue.destination as? RestaurantDetailsViewController,
                let sender = sender as? UIButton,
                // Unwrap the restaurant embedded within the button
                let restaurant = sender.layer.value(forKey: "restaurant") as? Restaurant else { return }
            
            destinationVC.restaurant = restaurant
        }
    }
}
// MARK: - MapView Delegate
extension RestaurantsMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Locate the restaurant associated with this annotation
        let annotationRestaurant = RestaurantController.shared.restaurants.first { (restaurant) -> Bool in
            return restaurant.name == annotation.title
        }
        // Customize the annotation marker
        let annotationView = MKMarkerAnnotationView()
        annotationView.titleVisibility = .visible
        annotationView.displayPriority = .required
        annotationView.canShowCallout = true
        annotationView.markerTintColor = UIColor(red: 67/255, green: 232/255, blue: 149/255, alpha: 1)
        let infoButton = UIButton(type: .detailDisclosure)
        
        // Embed the restaurant object within the button
        infoButton.layer.setValue(annotationRestaurant, forKey: "restaurant")
        
        infoButton.addTarget(self, action: #selector(segueToRestaurantDetails), for: .touchUpInside)
        annotationView.rightCalloutAccessoryView = infoButton
    
        return annotationView
    }
    
    // MARK: - MapView Delegate Action Methods
    @objc func segueToRestaurantDetails(_ sender: UIButton) {
        self.performSegue(withIdentifier: "toRestaurantDetails", sender: sender)
    }
}
