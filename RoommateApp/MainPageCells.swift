//
//  MainPageCells.swift
//  RoommateApp
//
//  Created by Alican Özsırma on 04/01/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class MainPageCells: UITableViewCell {
    
    @IBOutlet weak var hostname: UILabel!
 
    @IBOutlet weak var houseadress: UILabel!

    @IBOutlet weak var houseimage: UIImageView!
    
    @IBOutlet weak var housesize: UILabel!
    
    @IBOutlet weak var houseprice: UILabel!
    
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
        self.housestars.editable = false
        self.housestars.halfRatings = true
        self.housestars.floatRatings = false
        
        
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
