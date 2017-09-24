//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FiltersViewControllerDelegate {
    
    func filtersViewController(viewController: FiltersViewController, didSelectValuesForFilter filter: Filter) {
        self.currentFilter = filter

        var radius: NSNumber?
        if let distance = filter.distanceFilter as String? {
            radius = radiusInNumbers(distance: distance)
            
        }
        
        var sortMode = YelpSortMode.bestMatched
        if let sortBy = filter.sortByFilter as String? {
            sortMode = sortModeFromString(sortModeInString: sortBy)
            
        }

        Business.searchWithTerm(term: "Restaurants", sort: sortMode, categories: filter.categories, radius:radius, deals: true, completion: { (businesses: [Business]?, error: Error?) -> Void in

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
    }
    
    func radiusInNumbers(distance : String) -> NSNumber? {

        var radiusInMeters : NSNumber?
        switch distance {
        case "0.3 miles":
            radiusInMeters = 0.3/0.00062137 as NSNumber
            break
        case "1 mile":
            radiusInMeters = 1/0.00062137 as NSNumber
            break
        case "5 miles":
            radiusInMeters = 5/0.00062137 as NSNumber
            break
        case "20 miles":
            radiusInMeters = 20/0.00062137 as NSNumber
            break
        default:
            radiusInMeters = nil
            break
        }
        return radiusInMeters
    }
    
    func sortModeFromString(sortModeInString : String) -> YelpSortMode {
        
        var sortMode = YelpSortMode.bestMatched
        
        switch sortModeInString {
        case "Distance":
            sortMode = YelpSortMode.distance
            break
        case "Rating":
            sortMode = YelpSortMode.highestRated
            break
        case "Most Reviewed":
            sortMode = YelpSortMode.highestRated
            break
        default:
            sortMode = YelpSortMode.bestMatched
            break
        }
        return sortMode
    }
    
    
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
    var currentSearchString : String = ""
    var currentFilter: Filter?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleViewFrame = self.navigationItem.titleView?.frame ?? CGRect(x: 0, y: 0, width: 320, height: 44)
        let searchView: UISearchBar = UISearchBar.init(frame: CGRect(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: titleViewFrame.size.width, height: titleViewFrame.size.height )))
        searchView.delegate = self
        searchView.barTintColor = UIColor(red:0.94, green:0.71, blue:0.25, alpha:1.0)
        self.navigationItem.titleView = searchView
        
        
        self.businessesTableView.rowHeight = UITableViewAutomaticDimension
        self.businessesTableView.estimatedRowHeight = 100

        searchForBusinessWith(name: currentSearchString)
        
        self.currentFilter = Filter.init()
        
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
    
    func searchForBusinessWith(name : String) -> Void {
        let searchString = name
        Business.searchWithTerm(term: searchString, completion: { (businesses: [Business]?, error: Error?) -> Void in
            
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FiltersViewController" {
         
            guard let filtersNavController = segue.destination as? UINavigationController else {
                return
            }
            guard let destinationVC = filtersNavController.topViewController as? FiltersViewController else {
                return
            }
            
            destinationVC.currentFilter = self.currentFilter
            destinationVC.delegate = self
        }
    }
 
    
    
    public func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {// called when text starts editing
//        if (searchBar.text != "") {
//            searchActive = true;
//        }
//        else{
//            searchActive = false
//            self.moviesTableView.reloadData()
//            self.moviesCollectionView.reloadData()
//        }
//        searchForBusinessWith(name: searchBar.text!)
        
    }
//
//    
    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        // return NO to not resign first responder
        return true
    }
//
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        // called when text ends editing
        //searchActive = false;
//        searchForBusinessWith(name: searchBar.text!)
        searchBar.resignFirstResponder()

        
    }
//
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {// called when text changes (including clear)
        searchForBusinessWith(name: searchBar.text!)
//        self.filteredMovies = self.movies.filter({ (searchedmovie :FMMovie) -> Bool in
//            return (searchedmovie.origTitle?.contains(searchText))!
//        })
//        
//        if (searchBar.text == "") {
//            searchActive = false
//            self.moviesTableView.reloadData()
//            self.moviesCollectionView.reloadData()
//            return
//        }
//        
//        searchActive = true
//        print(self.filteredMovies.count)
//        
//        self.moviesTableView.reloadData()
//        self.moviesCollectionView.reloadData()
        
        
    }
//
//    public func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{ // called before text changes
//        return true
//    }
//    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {// called when keyboard search button pressed
//        searchBar.showsCancelButton = false
//        searchActive = false;
//        searchBar.text = ""
        searchForBusinessWith(name: searchBar.text!)
        searchBar.resignFirstResponder()
        
    }
//
//    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {// called when cancel button pressed
//        searchBar.showsCancelButton = false
//        searchActive = false;
//        searchBar.text = ""
//        searchBar.resignFirstResponder()
//        self.moviesTableView.reloadData()
//        self.moviesCollectionView.reloadData()
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let searchBar = self.navigationItem.titleView as? UISearchBar
        searchBar?.resignFirstResponder()
    }

    
}
