//
//  Comments.swift
//  RoommateApp
//
//  Created by Alican Özsırma on 11/04/16.
//  Copyright © 2016 mac. All rights reserved.
//

import Foundation

class Comments: BackendlessEntity {
    
    var house_id = String()
    var user_id = BackendlessUser()
    var comment = String()
    
}