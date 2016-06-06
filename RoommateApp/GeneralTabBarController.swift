//
//  GeneralTabBarController.swift
//  RoommateApp
//
//  Created by Alican Özsırma on 21/12/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class GeneralTabBarController: UITabBarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let tabItems = self.tabBar.items! as [UITabBarItem]
        let tabItem0 = tabItems[0] as UITabBarItem
        let tabItem1 = tabItems[1] as UITabBarItem
        let tabItem2 = tabItems[2] as UITabBarItem
        let tabItem3 = tabItems[3] as UITabBarItem
        let tabItem4 = tabItems[4] as UITabBarItem
        tabItem0.title = "Ana Sayfa"
        tabItem0.image = UIImage(named: "house-7")
        tabItem1.title = "Mesajlar"
        tabItem1.image = UIImage(named: "message-7")
        tabItem2.title = "Harita"
        tabItem3.image = UIImage(named: "map-pin")
        tabItem3.title = "Tavsiyeler"
        tabItem3.image = UIImage(named: "list-simple-star-7")
        tabItem4.title = "Ayarlar"
        tabItem4.image = UIImage(named: "spanner-7")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
