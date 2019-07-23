//
//  RestaurantController.swift
//  BottleRocketCodingChallenge
//
//  Created by Brayden Harris on 7/19/19.
//  Copyright © 2019 Brayden Harris. All rights reserved.
//

import UIKit

class RestaurantController {
    // MARK: - Properties
    var restaurants: [Restaurant] = []
    
    // MARK: - Singleton/Shared Instance
    static let shared = RestaurantController()
    
    // MARK: - Fetch Functions
    func fetchRestaurants(completion: @escaping (([Restaurant]?, NSError?) -> Void)) {
        guard let url = URL(string: "https://s3.amazonaws.com/br-codingexams/restaurants.json") else { completion(nil, NSError(domain: "URLErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "The URL is invalid"])); return }
        
        let dataTask = URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error as NSError? {
                print("Error fetching restuarants: \(error), \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                print("No restaurant data found")
                completion(nil, NSError(domain: "InvalidDataDomain", code: 2, userInfo: [NSLocalizedDescriptionKey: "No restaurant data found"]))
                return
            }
            
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                    guard let restaurants = jsonObject.value(forKey: "restaurants") as? [NSDictionary] else { completion(nil, NSError(domain: "NSDictionaryErrorDomain", code: 3, userInfo: [NSLocalizedDescriptionKey: "No values for key 'restaurants'"])); return }
                    
                    let dispatchGroup = DispatchGroup()
                    
                    for restaurant in restaurants {
                        dispatchGroup.enter()
                        guard let name = restaurant.value(forKey: "name") as? String,
                            let backgroundImageURL = restaurant.value(forKey: "backgroundImageURL") as? String,
                            let category = restaurant.value(forKey: "category") as? String,
                            let location = restaurant.value(forKey: "location") as? NSDictionary,
                            let formattedAddress = location.value(forKey: "formattedAddress") as? [String],
                            let lat = location.value(forKey: "lat") as? Double,
                            let long = location.value(forKey: "lng") as? Double else { continue }
                        
                        var phone: String?
                        var twitter: String?
                        
                        if let contact = restaurant.value(forKey: "contact") as? NSDictionary {
                            phone = contact.value(forKey: "formattedPhone") as? String
                            twitter = contact.value(forKey: "twitter") as? String
                        } else {
                            phone = nil
                            twitter = nil
                        }
                        
                        self.fetchBackgroundImage(fromURL: backgroundImageURL, completion: { (backgroundImage) in
                            guard let backgroundImage = backgroundImage else { completion(nil, NSError(domain: "DataTaskError", code: 4, userInfo: [NSLocalizedDescriptionKey: "Unable to fetch background image"])); return }
                            
                            self.restaurants.append(Restaurant(name: name, backgroundImage: backgroundImage, category: category, formattedPhone: phone, twitter: twitter, formattedAddress: formattedAddress, lat: lat, long: long))
                            dispatchGroup.leave()
                        })
                    }
                    
                    dispatchGroup.notify(queue: .main, execute: {
                        completion(self.restaurants, nil)
                    })
                }
            } catch {
                print("Error decoding restaurants from JSON: \(error), \(error.localizedDescription)")
                completion(nil, error as NSError?)
            }
        }
        dataTask.resume()
    }
    
    func fetchBackgroundImage(fromURL url: String, completion: @escaping ((UIImage?) -> Void)) {
        guard let imageURL = URL(string: url) else { completion(nil); return }
        
        URLSession.shared.dataTask(with: imageURL) { (data, _, error) in
            if let error = error {
                print("Error fetching background image from \(url): \(error), \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("No data found for \(url)'s image")
                completion(nil)
                return
            }
            
            completion(UIImage(data: data))
        }.resume()
    }
}
