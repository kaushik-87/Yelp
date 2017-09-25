//
//  BusinessDetailViewController.swift
//  Yelp
//
//  Created by Kaushik on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import AFNetworking
class BusinessDetailViewController: UIViewController {

    @IBOutlet weak var businessMapview: MKMapView!
    @IBOutlet weak var businessAddressLabel: UILabel!
    @IBOutlet weak var businessCategories: UILabel!
    @IBOutlet weak var businessPriceLabel: UILabel!
    @IBOutlet weak var businessReviewCount: UILabel!
    @IBOutlet weak var businessRatingImageView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessImageView: UIImageView!
    
    var business : Business? = nil

    
    func loadViewForBusiness(business : Business) -> Void {
        
            print(business)
        if let name = business.name {
            self.businessNameLabel.text = name

        }
            businessAddressLabel.text = business.address ?? ""
            businessReviewCount.text = "\(business.reviewCount ?? 0) Reviews"
            if (business.imageURL != nil){
                businessImageView.setImageWith(business.imageURL!)
            }
            businessCategories.text = business.categories ?? ""
            //            distanceLabel.text = business.distance
            if (business.ratingImageURL != nil) {
                businessRatingImageView.setImageWith(business.ratingImageURL!)
            }
            
            let locValue:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: business.latitude!, longitude: business.longitude!)
            let region = MKCoordinateRegionMakeWithDistance(locValue, 200, 200)
            self.businessMapview.setRegion(region, animated: false)
            let annotation = MKPointAnnotation()
            let coordinate = CLLocationCoordinate2D(latitude: business.latitude!, longitude: business.longitude!)
            annotation.coordinate = coordinate
            self.businessMapview.addAnnotation(annotation)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessNameLabel.text = self.business?.name
        //business?.name
        
        businessAddressLabel.text = self.business?.address ?? ""
        businessReviewCount.text = "\(self.business?.reviewCount ?? 0) Reviews"
        if (business?.imageURL != nil){
            businessImageView.setImageWith((self.business?.imageURL!)!)
        }
        businessCategories.text = self.business?.categories ?? ""
        //            distanceLabel.text = business.distance
        if (business?.ratingImageURL != nil) {
            businessRatingImageView.setImageWith((self.business?.ratingImageURL!)!)
        }

        let locValue:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: self.business!.latitude!, longitude: self.business!.longitude!)
        let region = MKCoordinateRegionMakeWithDistance(locValue, 200, 200)
        self.businessMapview.setRegion(region, animated: false)
        let annotation = MKPointAnnotation()
        let coordinate = CLLocationCoordinate2D(latitude: (business?.latitude!)!, longitude: (business?.longitude!)!)
        annotation.coordinate = coordinate
        self.businessMapview.addAnnotation(annotation)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
