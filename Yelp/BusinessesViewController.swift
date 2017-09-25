//
//  BusinessesViewController.swift
//  Yelp
//


import UIKit
import CoreLocation
class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FiltersViewControllerDelegate {
    
    @IBAction func switchViewAction(_ sender: Any) {
        
        if (isMapView) {
            self.businessesTableView.frame = self.view.bounds; //grab the view of a separate VC
            let rightBarButton = UIBarButtonItem.init(title: "Map", style: .plain, target: self, action: #selector(switchViewAction(_:)))
            rightBarButton.tintColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)

            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(1.0)
            UIView.setAnimationTransition(.flipFromLeft, for: (self.view)!, cache: true)
            self.mapViewController?.view.removeFromSuperview()
            self.view.addSubview(self.businessesTableView)
            UIView.commitAnimations()

        } else {
            self.mapViewController?.view.frame = self.view.bounds; //grab the view of a separate VC
            let rightBarButton = UIBarButtonItem.init(title: "List", style: .plain, target: self, action: #selector(switchViewAction(_:)))
            rightBarButton.tintColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
            self.navigationItem.rightBarButtonItem = rightBarButton
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(1.0)
            UIView.setAnimationTransition(.flipFromLeft, for: (self.view)!, cache: true)
            self.mapViewController?.view.removeFromSuperview()
            self.view.addSubview((self.mapViewController?.view)!)
            UIView.commitAnimations()
            self.mapViewController?.loadMapFor(businesses: self.businesses)
        }
        
        
        
        
        
        self.isMapView = self.isMapView ? false : true
    }
    
    @IBOutlet var switchViewButton: [UIBarButtonItem]!
    
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

        Business.searchWithTerm(term: "Restaurants", sort: sortMode, categories: filter.categories, radius:radius, deals: true, completion: { (businesses: [Business]?, totalResponseCount : Int?, error: Error?) -> Void in

            if (businesses != nil) {
                
                self.businesses = businesses
                self.canFetchMoreResults = self.businesses.count < totalResponseCount!
                if let businesses = businesses {
                    for business in businesses {
                        //                  print(business.name!)
                        //                  print(business.address!)
                    }
                }
                
                
                self.businessesTableView.reloadData()
            }else{
                self.canFetchMoreResults = false
            }

          
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
    var isMoreDataLoading = false
    var canFetchMoreResults = false
    var loadingMoreView:InfiniteScrollActivityView?
    var isMapView = false
    var mapViewController : MapViewController?
    let locationManager  = YelpLocationManager.sharedInstance

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.83, green:0.14, blue:0.14, alpha:1.0)
        self.navigationController?.navigationBar.isTranslucent = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onUserLocation), name: NSNotification.Name(rawValue: "didReceiveUserLocation"), object: nil)
        locationManager.requestForUserLocation()
        
        let titleViewFrame = self.navigationItem.titleView?.frame ?? CGRect(x: 0, y: 0, width: 320, height: 44)
        let searchView: UISearchBar = UISearchBar.init(frame: CGRect(origin: CGPoint.init(x: 0, y: 0), size: CGSize.init(width: titleViewFrame.size.width, height: titleViewFrame.size.height )))
        searchView.delegate = self
        searchView.barTintColor = UIColor(red:0.94, green:0.71, blue:0.25, alpha:1.0)
        self.navigationItem.titleView = searchView
        
        
        self.businessesTableView.rowHeight = UITableViewAutomaticDimension
        self.businessesTableView.estimatedRowHeight = 100

        
        let frame = CGRect(x: 0, y: self.businessesTableView.contentSize.height, width: self.businessesTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        self.businessesTableView.addSubview(loadingMoreView!)
        
        var insets = self.businessesTableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        self.businessesTableView.contentInset = insets
        
        
        
        
        self.currentFilter = Filter.init()
        
        self.mapViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
        self.mapViewController?.navController = self.navigationController
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
    
    func onUserLocation() -> Void {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name(rawValue: "didReceiveUserLocation"), object: nil)
        searchForBusinessWith(name: "Restaurants")
        
    }
    
    func searchForBusinessWith(name : String) -> Void {
        let searchString = name
        Business.searchWithTerm(term: searchString, completion: { (businesses: [Business]?, totalResponseCount:Int?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.canFetchMoreResults = self.businesses.count < totalResponseCount!
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
//                    print(business.address!)
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
        else if segue.identifier == "showDetail" {
            
            if let cell = sender as? BusinessCell {
                let indexPath = self.businessesTableView.indexPath(for: cell)
                
                let selectedBusiness = self.businesses[(indexPath?.row)!]
                
//                guard let filtersNavController = segue.destination as? UINavigationController else {
//                    return
//                }
                guard let destinationVC = segue.destination as? BusinessDetailViewController else {
                    return
                }

                destinationVC.business = selectedBusiness
                
                
            }
        }

    }
 
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let selectedBusiness = self.businesses[indexPath.row]
//        
//        let businessDetailView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BusinessDetailViewController") as? BusinessDetailViewController
//        self.navigationController?.pushViewController(businessDetailView!, animated: true)
//        
//        businessDetailView?.loadViewForBusiness(business: selectedBusiness)
        
        
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
        
        
        if self.canFetchMoreResults {
            if (!isMoreDataLoading) {
                // Calculate the position of one screen length before the bottom of the results
                let scrollViewContentHeight = self.businessesTableView.contentSize.height
                let scrollOffsetThreshold = scrollViewContentHeight - self.businessesTableView.bounds.size.height
                
                let frame = CGRect(x: 0, y: self.businessesTableView.contentSize.height, width: self.businessesTableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                // When the user has scrolled past the threshold, start requesting
                if(scrollView.contentOffset.y > scrollOffsetThreshold && self.businessesTableView.isDragging) {
                    isMoreDataLoading = true
                    
                    
                    
                    // ... Code to load more results ...
                    Business.searchWithTerm(term: "Restaurants", limit: 0, offset: self.businesses.count ,completion: { (businesses: [Business]?, totalResponseCount: Int?,  error: Error?) -> Void in
                        self.isMoreDataLoading = false
                        self.canFetchMoreResults = self.businesses.count < totalResponseCount!
                        self.loadingMoreView!.stopAnimating()

                        print(self.businesses.count)
                        if let businesses = businesses {
                            for business in businesses {
                                print(business.name!)
                                //                    print(business.address!)
                                self.businesses.append(business)
                            }
                        }
                        self.businessesTableView.reloadData()
                    }
                    )
                }
            }
        }

    }
    
}
