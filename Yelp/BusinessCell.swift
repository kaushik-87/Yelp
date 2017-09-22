//
//  BusinessCell.swift
//  Yelp
//
//  Created by Kaushik on 9/21/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import AFNetworking
class BusinessCell: UITableViewCell {
    @IBOutlet weak var ratingsImageView: UIImageView!

    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    var business: Business! {
        didSet {
            nameLabel.text = business.name
            addressLabel.text = business.address
            reviewsCountLabel.text = "\(business.reviewCount ?? 0) Reviews"
            thumbImageView.setImageWith(business.imageURL!)
            categoriesLabel.text = business.categories
            distanceLabel.text = business.distance
            ratingsImageView.setImageWith(business.ratingImageURL!)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.thumbImageView.layer.cornerRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
