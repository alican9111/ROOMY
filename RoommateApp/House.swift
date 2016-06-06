//
//  House.swift
//  RoommateApp
//
//  Created by Apple on 22/02/16.
//  Copyright © 2016 mac. All rights reserved.
//

import Foundation
import UIKit

class House : BackendlessEntity {
    
    var user_id : BackendlessUser? 
    var aboutowner : String = ""
    var sizeofhouse : String = ""
    var iscigarette : NSNumber  = false
    var isfurniture : NSNumber = false
    var ishotwater : NSNumber = false
    var isaircondition : NSNumber = false
    var iscellar : NSNumber = false
    var isbalcony : NSNumber = false
    var isnaturalgas : NSNumber = false
    var iscook : NSNumber = false
    var isguest : NSNumber  = false
    var numberofperson : String?
    var whoissearched : String?
    var job : String?
    var adress : String = ""
    var town : String?
    var city : String?
    var price : Double = 0.0
    var isactive : NSNumber = false
    var explanation : String?
    var ownerId : String = ""
    var numberofad : String = ""
    var latitude : String = ""
    var longitude : String = ""
    var average : Double = 0
    
}
