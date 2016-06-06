//
//  MessageCell.swift
//  RoommateApp
//
//  Created by Apple on 14/03/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var profilephoto: UIImageView!
    @IBOutlet weak var hostname: UILabel!
    
    @IBOutlet weak var topic: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profilephoto.layer.cornerRadius = 8.0
        profilephoto.clipsToBounds = true
        profilephoto.layer.masksToBounds = true
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
