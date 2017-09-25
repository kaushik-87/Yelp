//
//  MapViewController.swift
//  Yelp
//
//  Created by Kaushik on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class MapViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var businessesMapView: MKMapView!

    var businesses : [Business]?
    var annotations : [MKPointAnnotation] = []
    let locationManager  = YelpLocationManager.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onUserLocation), name: NSNotification.Name(rawValue: "didReceiveUserLocation"), object: nil)
        locationManager.requestForUserLocation()
    }
    
    
    func onUserLocation() -> Void {
        let locValue:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: locationManager.userLatitude!, longitude: locationManager.userLongitude!)
        let region = MKCoordinateRegionMakeWithDistance(locValue, 2000, 2000)
        self.businessesMapView.setRegion(region, animated: true)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "didReceiveUserLocation"), object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMapFor(businesses: [Business]?) -> Void {
        self.annotations = []
        for business in businesses! {
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: business.latitude!, longitude: business.longitude!)
            annotation.coordinate = coordinate
//            annotation.title = business.name
//            annotation.subtitle = business.categories
            self.annotations.append(annotation)
        }
        

        self.businessesMapView.addAnnotations(self.annotations)
        
        
        
        //self.businessesMapView.addAnnotations([MKAnnotation])
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
