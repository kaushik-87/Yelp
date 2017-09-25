//
//  YelpLocationManager.swift
//  Yelp
//
//  Created by Kaushik on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation
class YelpLocationManager: NSObject, CLLocationManagerDelegate {
    
    let locationManager  = CLLocationManager()
    
    var userLatitude: Double?
    var userLongitude: Double?
    var didFetchLocation = false
    static let sharedInstance = YelpLocationManager()
    func requestForUserLocation() -> Void {
        if didFetchLocation {
            let notificationCenter = NotificationCenter.default
            notificationCenter.post(name: NSNotification.Name(rawValue: "didReceiveUserLocation"), object: nil)

            return
        }
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }


    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.userLatitude = locValue.latitude
        self.userLongitude = locValue.longitude
        didFetchLocation = true
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: NSNotification.Name(rawValue: "didReceiveUserLocation"), object: nil)
        self.locationManager.stopUpdatingLocation()
    }
}
