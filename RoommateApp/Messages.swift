//
//  Message.swift
//  RoommateApp
//
//  Created by Apple on 14/03/16.
//  Copyright © 2016 mac. All rights reserved.
//

import Foundation
import UIKit

class Messages : BackendlessEntity {
    
    var sender_id = BackendlessUser()
    var receiver_id = BackendlessUser()
    var message_topic : String = ""
    var message_content : String = ""
    var numberofad : String = ""
    
}