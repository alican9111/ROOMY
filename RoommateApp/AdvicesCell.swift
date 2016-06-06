//
//  AdvicesCell.swift
//  RoommateApp
//
//  Created by Alican Özsırma on 12/04/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class AdvicesCell: UITableViewCell {
    
    @IBOutlet weak var fullname: UILabel!
    
    @IBOutlet weak var aboutowner: UILabel!

    @IBOutlet weak var adress: UILabel!
    
    @IBOutlet weak var numberofad: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var houseimage: UIImageView!
    
    @IBOutlet weak var likecount: UILabel!
    @IBOutlet weak var housestars: FloatRatingView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //------star
        // Required float rating view params
        self.housestars.emptyImage = UIImage(named: "StarEmpty")
        self.housestars.fullImage = UIImage(named: "StarFull")
        // Optional params
        self.housestars.contentMode = UIViewContentMode.ScaleAspectFit
        self.housestars.maxRating = 5
        self.housestars.minRating = 1
        self.housestars.rating = 2.5
        self.housestars.editable = true
        self.housestars.halfRatings = true
        self.housestars.floatRatings = false

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
