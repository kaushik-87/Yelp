//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell

        if let business = businesses[indexPath.row] as Business?{
            cell.business = business

        }
        return cell
    }

    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return self.businesses.count

        }else{
            return 0
        }
    }

    
    @IBOutlet weak var businessesTableView: UITableView!
    var businesses: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.businessesTableView.rowHeight = UITableViewAutomaticDimension
        self.businessesTableView.estimatedRowHeight = 100
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
            }
            self.businessesTableView.reloadData()
            }
        )
        
         //Example of Yelp search with more search options specified
//        Business.searchWithTerm(term: "Restaurants", sort: YelpSortMode.distance, categories: ["asianfusion", "burgers"], deals: true, completion: { (businesses: [Business]?, error: Error?) -> Void in
//            
//            self.businesses = businesses
//            if let businesses = businesses {
//                for business in businesses {
//                    print(business.name!)
//                    print(business.address!)
//                }
//            }
//            
//        }
//    )
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
