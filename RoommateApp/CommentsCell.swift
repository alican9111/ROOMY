//
//  CommentsCell.swift
//  RoommateApp
//
//  Created by Alican Özsırma on 11/04/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class CommentsCell: UITableViewCell {

    @IBOutlet weak var profilephoto: UIImageView!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var comment: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
