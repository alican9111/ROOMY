//
//  HostModeCells.swift
//  RoommateApp
//
//  Created by Apple on 26/01/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class HostModeCells: UITableViewCell {
    
    @IBOutlet weak var houseadress: UILabel!
    @IBOutlet weak var housesize: UILabel!
    @IBOutlet weak var houseimage: UIImageView!
    @IBOutlet weak var active: UISwitch!
    @IBOutlet weak var houseprice: UILabel!
    @IBOutlet weak var houseid: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        houseimage.layer.cornerRadius = 8.0
        houseimage.clipsToBounds = true

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
