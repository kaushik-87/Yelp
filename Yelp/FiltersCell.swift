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

@objc protocol FiltersCellDelegate {
    @objc optional func filtersCell(filterCell: FiltersCell, didChangeValue value: Bool)
}

class FiltersCell: UITableViewCell {

    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var accessoryImageView: UIImageView!
    
    @IBOutlet weak var filterSwitch: UISwitch!
    weak var delegate : FiltersCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        filterSwitch.addTarget(self, action: #selector(switchValueChanged), for: UIControlEvents.valueChanged)
    }

    func switchValueChanged() -> Void {
        
        if delegate != nil {
            delegate?.filtersCell?(filterCell: self, didChangeValue: self.filterSwitch.isOn)
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
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
