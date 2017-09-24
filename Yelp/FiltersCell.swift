//
//  FiltersCell.swift
//  Yelp
//
//  Created by Kaushik on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

enum FilterCellStyle {
    case FilterCellStyleSwitch
    case FilterCellStyleExpandable
    case FilterCellStyleCheckMark
}

class FiltersCell: UITableViewCell {

    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var accessoryImageView: UIImageView!
    
    @IBOutlet weak var filterSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
//        if (selected){
//            self.accessoryImageView.image = UIImage(named: "Checkmark_check", in: nil, compatibleWith: nil)
//        }

// Configure the view for the selected state
//            let cellStyle = self.filterCellStyle
//            switch cellStyle! {
//            case .FilterCellStyleSwitch:
//
//                break
//            case .FilterCellStyleCheckMark:
//        if selected {
//            self.accessoryImageView.image = UIImage(named: "Checkmark_check", in: nil, compatibleWith: nil)
//
//        }
//                break
//            default:
//                break
//            }
    }
    
    var filterCellStyle : FilterCellStyle! {
        didSet {
            switch filterCellStyle! {
            case .FilterCellStyleSwitch:
                self.accessoryImageView.isHidden = true
                self.filterSwitch.isHidden = false

                break
            case .FilterCellStyleExpandable:
                self.accessoryImageView.isHidden = false
                self.filterSwitch.isHidden = true
                self.accessoryImageView.image = UIImage(named: "DownArrow", in: nil, compatibleWith: nil)
                break
            case .FilterCellStyleCheckMark:
                self.accessoryImageView.isHidden = false
                self.filterSwitch.isHidden = true
                self.accessoryImageView.image = UIImage(named: "checkmark_uncheck", in: nil, compatibleWith: nil)

                break
            default:
                break
            }

        }
    }
    
    func setFilterForDeal (isDealOn : Bool) {
        self.filterSwitch.isOn = isDealOn
    }
    
    var filter : Filter! {
        didSet {
            
//            print(filter)
//            print(self.filterLabel.text)
            let cellStyle = self.filterCellStyle
            switch cellStyle! {
            case .FilterCellStyleSwitch:
                if (self.filterLabel.text == "Offering a Deal"){
                    self.filterSwitch.isOn = filter.dealOffer
                }
                else{
                    self.filterSwitch.isOn = filter.categories.contains(self.filterLabel.text!)
                }
                
                break
            case .FilterCellStyleCheckMark:
                if(filter.distanceFilter == self.filterLabel.text){
                    self.accessoryImageView.image = UIImage(named: "Checkmark_check", in: nil, compatibleWith: nil)
                }
                else if(filter.sortByFilter == self.filterLabel.text){
                    self.accessoryImageView.image = UIImage(named: "Checkmark_check", in: nil, compatibleWith: nil)
                }
                else{
                    self.accessoryImageView.image = UIImage(named: "checkmark_uncheck", in: nil, compatibleWith: nil)

                }
                break
            default:
                break
            }
        }
    }


}
