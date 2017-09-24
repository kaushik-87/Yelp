//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Kaushik on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit


class Filter :NSObject {
    
    var dealOffer : Bool
    var distanceFilter : String
    var sortByFilter : String
    var categories : [String]
    override init() {
        dealOffer = false
        distanceFilter = "Auto"
        sortByFilter = "Best Match"
        categories = []
    }

}

@objc protocol FiltersViewControllerDelegate {
     @objc optional func filtersViewController(viewController: FiltersViewController, didSelectValuesForFilter filter: Filter)
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersCellDelegate {
    
    
    @IBAction func searchWithFilters(_ sender: Any) {
                dismiss(animated: true, completion: nil)
        if delegate != nil {
            delegate?.filtersViewController?(viewController: self, didSelectValuesForFilter: self.currentFilter!)
        }
        
    }
   
    @IBAction func cancelFilters(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var filtersTableView: UITableView!
    
    let distanceArray = ["Auto", "0.3 miles", "1 mile", "5 miles", "20 miles"]
    let sortByArray = ["Best Match", "Distance", "Rating", "Most Reviewed"]
    let categories = [["name" : "Afghan", "code": "afghani"],
                      ["name" : "African", "code": "african"],
                      ["name" : "American, New", "code": "newamerican"],
                      ["name" : "American, Traditional", "code": "tradamerican"],
                      ["name" : "Arabian", "code": "arabian"],
                      ["name" : "Argentine", "code": "argentine"],
                      ["name" : "Armenian", "code": "armenian"],
                      ["name" : "Asian Fusion", "code": "asianfusion"],
                      ["name" : "Asturian", "code": "asturian"],
                      ["name" : "Australian", "code": "australian"],
                      ["name" : "Austrian", "code": "austrian"],
                      ["name" : "Baguettes", "code": "baguettes"],
                      ["name" : "Bangladeshi", "code": "bangladeshi"],
                      ["name" : "Barbeque", "code": "bbq"],
                      ["name" : "Basque", "code": "basque"],
                      ["name" : "Bavarian", "code": "bavarian"],
                      ["name" : "Beer Garden", "code": "beergarden"],
                      ["name" : "Beer Hall", "code": "beerhall"],
                      ["name" : "Beisl", "code": "beisl"],
                      ["name" : "Belgian", "code": "belgian"],
                      ["name" : "Bistros", "code": "bistros"],
                      ["name" : "Black Sea", "code": "blacksea"],
                      ["name" : "Brasseries", "code": "brasseries"],
                      ["name" : "Brazilian", "code": "brazilian"],
                      ["name" : "Breakfast & Brunch", "code": "breakfast_brunch"],
                      ["name" : "British", "code": "british"],
                      ["name" : "Buffets", "code": "buffets"],
                      ["name" : "Bulgarian", "code": "bulgarian"],
                      ["name" : "Burgers", "code": "burgers"],
                      ["name" : "Burmese", "code": "burmese"],
                      ["name" : "Cafes", "code": "cafes"],
                      ["name" : "Cafeteria", "code": "cafeteria"],
                      ["name" : "Cajun/Creole", "code": "cajun"],
                      ["name" : "Cambodian", "code": "cambodian"],
                      ["name" : "Canadian", "code": "New)"],
                      ["name" : "Canteen", "code": "canteen"],
                      ["name" : "Caribbean", "code": "caribbean"],
                      ["name" : "Catalan", "code": "catalan"],
                      ["name" : "Chech", "code": "chech"],
                      ["name" : "Cheesesteaks", "code": "cheesesteaks"],
                      ["name" : "Chicken Shop", "code": "chickenshop"],
                      ["name" : "Chicken Wings", "code": "chicken_wings"],
                      ["name" : "Chilean", "code": "chilean"],
                      ["name" : "Chinese", "code": "chinese"],
                      ["name" : "Comfort Food", "code": "comfortfood"],
                      ["name" : "Corsican", "code": "corsican"],
                      ["name" : "Creperies", "code": "creperies"],
                      ["name" : "Cuban", "code": "cuban"],
                      ["name" : "Curry Sausage", "code": "currysausage"],
                      ["name" : "Cypriot", "code": "cypriot"],
                      ["name" : "Czech", "code": "czech"],
                      ["name" : "Czech/Slovakian", "code": "czechslovakian"],
                      ["name" : "Danish", "code": "danish"],
                      ["name" : "Delis", "code": "delis"],
                      ["name" : "Diners", "code": "diners"],
                      ["name" : "Dumplings", "code": "dumplings"],
                      ["name" : "Eastern European", "code": "eastern_european"],
                      ["name" : "Ethiopian", "code": "ethiopian"],
                      ["name" : "Fast Food", "code": "hotdogs"],
                      ["name" : "Filipino", "code": "filipino"],
                      ["name" : "Fish & Chips", "code": "fishnchips"],
                      ["name" : "Fondue", "code": "fondue"],
                      ["name" : "Food Court", "code": "food_court"],
                      ["name" : "Food Stands", "code": "foodstands"],
                      ["name" : "French", "code": "french"],
                      ["name" : "French Southwest", "code": "sud_ouest"],
                      ["name" : "Galician", "code": "galician"],
                      ["name" : "Gastropubs", "code": "gastropubs"],
                      ["name" : "Georgian", "code": "georgian"],
                      ["name" : "German", "code": "german"],
                      ["name" : "Giblets", "code": "giblets"],
                      ["name" : "Gluten-Free", "code": "gluten_free"],
                      ["name" : "Greek", "code": "greek"],
                      ["name" : "Halal", "code": "halal"],
                      ["name" : "Hawaiian", "code": "hawaiian"],
                      ["name" : "Heuriger", "code": "heuriger"],
                      ["name" : "Himalayan/Nepalese", "code": "himalayan"],
                      ["name" : "Hong Kong Style Cafe", "code": "hkcafe"],
                      ["name" : "Hot Dogs", "code": "hotdog"],
                      ["name" : "Hot Pot", "code": "hotpot"],
                      ["name" : "Hungarian", "code": "hungarian"],
                      ["name" : "Iberian", "code": "iberian"],
                      ["name" : "Indian", "code": "indpak"],
                      ["name" : "Indonesian", "code": "indonesian"],
                      ["name" : "International", "code": "international"],
                      ["name" : "Irish", "code": "irish"],
                      ["name" : "Island Pub", "code": "island_pub"],
                      ["name" : "Israeli", "code": "israeli"],
                      ["name" : "Italian", "code": "italian"],
                      ["name" : "Japanese", "code": "japanese"],
                      ["name" : "Jewish", "code": "jewish"],
                      ["name" : "Kebab", "code": "kebab"],
                      ["name" : "Korean", "code": "korean"],
                      ["name" : "Kosher", "code": "kosher"],
                      ["name" : "Kurdish", "code": "kurdish"],
                      ["name" : "Laos", "code": "laos"],
                      ["name" : "Laotian", "code": "laotian"],
                      ["name" : "Latin American", "code": "latin"],
                      ["name" : "Live/Raw Food", "code": "raw_food"],
                      ["name" : "Lyonnais", "code": "lyonnais"],
                      ["name" : "Malaysian", "code": "malaysian"],
                      ["name" : "Meatballs", "code": "meatballs"],
                      ["name" : "Mediterranean", "code": "mediterranean"],
                      ["name" : "Mexican", "code": "mexican"],
                      ["name" : "Middle Eastern", "code": "mideastern"],
                      ["name" : "Milk Bars", "code": "milkbars"],
                      ["name" : "Modern Australian", "code": "modern_australian"],
                      ["name" : "Modern European", "code": "modern_european"],
                      ["name" : "Mongolian", "code": "mongolian"],
                      ["name" : "Moroccan", "code": "moroccan"],
                      ["name" : "New Zealand", "code": "newzealand"],
                      ["name" : "Night Food", "code": "nightfood"],
                      ["name" : "Norcinerie", "code": "norcinerie"],
                      ["name" : "Open Sandwiches", "code": "opensandwiches"],
                      ["name" : "Oriental", "code": "oriental"],
                      ["name" : "Pakistani", "code": "pakistani"],
                      ["name" : "Parent Cafes", "code": "eltern_cafes"],
                      ["name" : "Parma", "code": "parma"],
                      ["name" : "Persian/Iranian", "code": "persian"],
                      ["name" : "Peruvian", "code": "peruvian"],
                      ["name" : "Pita", "code": "pita"],
                      ["name" : "Pizza", "code": "pizza"],
                      ["name" : "Polish", "code": "polish"],
                      ["name" : "Portuguese", "code": "portuguese"],
                      ["name" : "Potatoes", "code": "potatoes"],
                      ["name" : "Poutineries", "code": "poutineries"],
                      ["name" : "Pub Food", "code": "pubfood"],
                      ["name" : "Rice", "code": "riceshop"],
                      ["name" : "Romanian", "code": "romanian"],
                      ["name" : "Rotisserie Chicken", "code": "rotisserie_chicken"],
                      ["name" : "Rumanian", "code": "rumanian"],
                      ["name" : "Russian", "code": "russian"],
                      ["name" : "Salad", "code": "salad"],
                      ["name" : "Sandwiches", "code": "sandwiches"],
                      ["name" : "Scandinavian", "code": "scandinavian"],
                      ["name" : "Scottish", "code": "scottish"],
                      ["name" : "Seafood", "code": "seafood"],
                      ["name" : "Serbo Croatian", "code": "serbocroatian"],
                      ["name" : "Signature Cuisine", "code": "signature_cuisine"],
                      ["name" : "Singaporean", "code": "singaporean"],
                      ["name" : "Slovakian", "code": "slovakian"],
                      ["name" : "Soul Food", "code": "soulfood"],
                      ["name" : "Soup", "code": "soup"],
                      ["name" : "Southern", "code": "southern"],
                      ["name" : "Spanish", "code": "spanish"],
                      ["name" : "Steakhouses", "code": "steak"],
                      ["name" : "Sushi Bars", "code": "sushi"],
                      ["name" : "Swabian", "code": "swabian"],
                      ["name" : "Swedish", "code": "swedish"],
                      ["name" : "Swiss Food", "code": "swissfood"],
                      ["name" : "Tabernas", "code": "tabernas"],
                      ["name" : "Taiwanese", "code": "taiwanese"],
                      ["name" : "Tapas Bars", "code": "tapas"],
                      ["name" : "Tapas/Small Plates", "code": "tapasmallplates"],
                      ["name" : "Tex-Mex", "code": "tex-mex"],
                      ["name" : "Thai", "code": "thai"],
                      ["name" : "Traditional Norwegian", "code": "norwegian"],
                      ["name" : "Traditional Swedish", "code": "traditional_swedish"],
                      ["name" : "Trattorie", "code": "trattorie"],
                      ["name" : "Turkish", "code": "turkish"],
                      ["name" : "Ukrainian", "code": "ukrainian"],
                      ["name" : "Uzbek", "code": "uzbek"],
                      ["name" : "Vegan", "code": "vegan"],
                      ["name" : "Vegetarian", "code": "vegetarian"],
                      ["name" : "Venison", "code": "venison"],
                      ["name" : "Vietnamese", "code": "vietnamese"],
                      ["name" : "Wok", "code": "wok"],
                      ["name" : "Wraps", "code": "wraps"],
                      ["name" : "Yugoslav", "code": "yugoslav"]]
    var filtersDictionary = [["Deal" : "Offering a Deal"],
                             ["Distance" : [String]()],
                             ["Sort By" : [String]()],
                             ["Category" : [[String : String]]()]]
    
    var currentFilter : Filter? = nil
    
    var didExpandDistanceSection : Bool = false
    var didExpandSortBySection : Bool = false
    weak var delegate : FiltersViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filtersDictionary = [["Deal" : "Offering a Deal"],
                             ["Distance" : distanceArray],
                             ["Sort By" : sortByArray],
                             ["Category" : categories]]
        
        //self.currentFilter = Filter()

            //Filter.init(dealOffer: false, distanceFilter: "0.3 miles", sortByFilter: "Rating", categories: ["Afghan", "American, New", "Canadian"])
        self.filtersTableView.rowHeight = UITableViewAutomaticDimension
        self.filtersTableView.estimatedRowHeight = 100
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FiltersCell", for: indexPath) as! FiltersCell
        var cellTitle = ""
        switch indexPath.section {
        case 0:
            cellTitle = self.filtersDictionary[0]["Deal"] as! String
            cell.filterCellStyle = FilterCellStyle.FilterCellStyleSwitch
            cell.filter = self.currentFilter

            break
        case 1:
            if didExpandDistanceSection {
                let distanceArr : [String] = self.filtersDictionary[1]["Distance"] as! [String]
                cellTitle =  distanceArr[indexPath.row]
                cell.filterCellStyle = FilterCellStyle.FilterCellStyleCheckMark
            }else {
                cellTitle = (self.currentFilter?.distanceFilter)!
                cell.filterCellStyle = FilterCellStyle.FilterCellStyleExpandable
            }

            break
        case 2:
            if didExpandSortBySection {
                let sortByArr : [String] = self.filtersDictionary[2]["Sort By"] as! [String]
                cellTitle =  sortByArr[indexPath.row]
                cell.filterCellStyle = FilterCellStyle.FilterCellStyleCheckMark


            }else{
                cellTitle = (self.currentFilter?.sortByFilter)!
                cell.filterCellStyle = FilterCellStyle.FilterCellStyleExpandable
            }

            break
        case 3:
            let categoryList : [[String : String]] = self.filtersDictionary[3]["Category"] as! [[String : String]]
            cellTitle =  categoryList[indexPath.row]["name"]!
            cell.filterCellStyle = FilterCellStyle.FilterCellStyleSwitch
            cell.filter = self.currentFilter


            break
        default:
            break
        }
        
        cell.filterLabel.text = cellTitle
        cell.filter = self.currentFilter
        cell.delegate = self
        return cell
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rowCount = 0
        switch section {
        case 0:
            rowCount =  1;
            break
        case 1:
            if didExpandDistanceSection {
                let distanceArr : [String] = self.filtersDictionary[section]["Distance"] as! [String]
                rowCount =  distanceArr.count
            }else{
                rowCount = 1
            }

            break
        case 2:
            if didExpandSortBySection {
                let sortByArr : [String] = self.filtersDictionary[section]["Sort By"] as! [String]
                rowCount =  sortByArr.count
            }else{
                rowCount = 1
            }

            break
        case 3:
            let categoryList : [[String : String]] = self.filtersDictionary[section]["Category"] as! [[String : String]]
            rowCount =  categoryList.count
            break
        default:
            break
        }
        return rowCount
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filtersDictionary.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var headerTitle = ""
        switch section {
        case 0:
            break
        case 1:
            let distanceDict : [String : [String]] = self.filtersDictionary[section] as! [String : [String]]
            headerTitle =  Array(distanceDict.keys)[0]
            break
        case 2:
            let sortByDict : [String : [String]] = self.filtersDictionary[section] as! [String : [String]]
            headerTitle =  Array(sortByDict.keys)[0]
            break
        case 3:
            let categoryListDict : [String : [[String : String]]] = self.filtersDictionary[section] as! [String : [[String : String]]]
            headerTitle =  Array(categoryListDict.keys)[0]
            break
        default:
            break
        }
        return headerTitle
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:

            break
        case 1:
            let distanceArr : [String] = self.filtersDictionary[1]["Distance"] as! [String]
            didExpandDistanceSection = didExpandDistanceSection ? false : true
            if didExpandDistanceSection == false {
                self.currentFilter?.distanceFilter = distanceArr[indexPath.row]
            }
            tableView.reloadSections(IndexSet(integer:indexPath.section), with: .automatic)

            break
        case 2:
            let sortByArr : [String] = self.filtersDictionary[2]["Sort By"] as! [String]
            didExpandSortBySection = didExpandSortBySection ? false : true
            if didExpandSortBySection == false {
                self.currentFilter?.sortByFilter =  sortByArr[indexPath.row]
            }
            tableView.reloadSections(IndexSet(integer:indexPath.section), with: .automatic)

            break
        default:
            break
        }

        
    }
    
    func filtersCell(filterCell: FiltersCell, didChangeValue value: Bool) {
        
        let indexPath = self.filtersTableView.indexPath(for: filterCell) ?? IndexPath(row: 0, section: 0)
        
        switch indexPath.section {
        case 0:
            self.currentFilter?.dealOffer = value
            break
        case 3:
            let categoryList : [[String : String]] = self.filtersDictionary[3]["Category"] as! [[String : String]]
            self.currentFilter?.categories.append(categoryList[indexPath.row]["name"]!)
            break
        default:
            break
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
