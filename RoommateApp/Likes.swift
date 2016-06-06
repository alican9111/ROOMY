//
//  Like.swift
//  RoommateApp
//
//  Created by Alican Özsırma on 22/03/16.
//  Copyright © 2016 mac. All rights reserved.
//

import Foundation

class Likes : BackendlessEntity{
    
    var house_id = String()
    var liked_id = BackendlessUser()
    var score = Double()
    
}