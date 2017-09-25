//
//  MapViewController.swift
//  Yelp
//
//  Created by Kaushik on 9/24/17.
//

import UIKit
import MapKit
import CoreLocation
class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    @IBOutlet weak var businessesMapView: MKMapView!

    var businesses : [Business]?
    var annotations : [MKPointAnnotation] = []
    let locationManager  = YelpLocationManager.sharedInstance
    var navController : UINavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.businessesMapView.delegate = self
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
        self.businesses = businesses
        for business in businesses! {
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: business.latitude!, longitude: business.longitude!)
            annotation.coordinate = coordinate
            annotation.title = business.name
            annotation.subtitle = business.categories
            self.annotations.append(annotation)
        }
        

        self.businessesMapView.addAnnotations(self.annotations)
        
        
        
        //self.businessesMapView.addAnnotations([MKAnnotation])
    }

    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            view!.canShowCallout = true
            view!.rightCalloutAccessoryView = UIButton.init(type: .detailDisclosure) as UIView
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let index = (self.annotations as NSArray).index(of: view.annotation ?? 0)
        if index >= 0 {
            //self.showDetailsForResult(self.results[index])
            
            let selectedBusiness = self.businesses?[index]
            //
            let businessDetailView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BusinessDetailViewController") as? BusinessDetailViewController
            self.navController?.pushViewController(businessDetailView!, animated: true)
            //
            businessDetailView?.business = selectedBusiness
            
            
            
        }
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
