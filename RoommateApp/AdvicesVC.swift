//
//  AdvicesVC.swift
//  RoommateApp
//
//  Created by Alican Özsırma on 11/04/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class AdvicesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var houseimagearray = [String]()
    var hostfullnamearray = [String]()
    var houses = [House]()
    
    var backendless = Backendless.sharedInstance()
    let refreshControl : UIRefreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!
    
    
    
    @IBAction func action_segment(sender: AnyObject) {
        switch (sender.selectedSegmentIndex)
        {
        case 0:
            //------Show UIActivity-------
            let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spiningActivity.labelText = "Top 50 Hazırlanıyor"
            spiningActivity.detailsLabelText = "Lütfen Bekleyin"
            //-----------------------------------
            let query = BackendlessDataQuery()
            let options = QueryOptions()
            options.sortBy(["average DESC"])
            query.queryOptions = options
            removeallarray()
            getHouseAsync(query)
            spiningActivity.hide(true)
            
              let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:#selector(AdvicesVC.do_table_refresh), userInfo: nil, repeats: false)
        case 1:
            //------Show UIActivity-------
            let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spiningActivity.labelText = "Size Göre Hazırlanıyor"
            spiningActivity.detailsLabelText = "Lütfen Bekleyin"
            //-----------------------------------
            let query = BackendlessDataQuery()
            query.whereClause = "city = '\(backendless.userService.currentUser.getProperty("city"))' and isactive = true and whoissearched = '\(backendless.userService.currentUser.getProperty("gender"))'"
            removeallarray()
            getHouseAsync(query)
            spiningActivity.hide(true)
            let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:#selector(AdvicesVC.do_table_refresh), userInfo: nil, repeats: false)
        default: break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        
        refreshControl.addTarget(self, action: #selector(MainPageVC.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
    
        //------Show UIActivity-------
        let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spiningActivity.labelText = "Top 50 Hazırlanıyor"
        spiningActivity.detailsLabelText = "Lütfen Bekleyin"
        //-----------------------------------
        let query = BackendlessDataQuery()
        let options = QueryOptions()
        options.sortBy(["average DESC"])
        query.queryOptions = options
        removeallarray()
        getHouseAsync(query)
        spiningActivity.hide(true)
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:#selector(AdvicesVC.do_table_refresh), userInfo: nil, repeats: false)
        
        self.do_table_refresh()
        
    }
    
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
    
    func refresh(sender:AnyObject)
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
        self.refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("AdvicesCell", forIndexPath: indexPath) as! AdvicesCell
        
        
        cell.adress.text = self.houses[indexPath.row].town!+"/"+self.houses[indexPath.row].city!
        cell.aboutowner.text = self.houses[indexPath.row].aboutowner
        cell.price.text = String(self.houses[indexPath.row].price)+"TL"
        cell.fullname.text = self.hostfullnamearray[indexPath.row]
        cell.numberofad.text = self.houses[indexPath.row].numberofad
        cell.housestars.rating = Float(self.houses[indexPath.row].average)
        
        //-----Radius image
        let imageViewSize = 70 as CGFloat
        cell.houseimage.frame.size.height = imageViewSize
        cell.houseimage.frame.size.width = imageViewSize
        cell.houseimage.layer.cornerRadius = 8.0
        cell.houseimage.clipsToBounds = true
        //-------------------
        
        self.backendless.file.listing("/homes/"+self.houseimagearray[indexPath.row]+"/", pattern:"mainphoto.jpeg", recursive:false,
                                      response: { ( result : BackendlessCollection!) -> () in
                                        let files = result.getCurrentPage()
                                        for file in files {
                                            
                                            dispatch_async(dispatch_get_main_queue(), {
                                                cell.houseimage.image = (UIImage(data: NSData(contentsOfURL: NSURL(string:file.publicUrl)!)!))
                                            })
                                        }},
                                      error: { ( fault : Fault!) -> () in
                                        print("Server reported an error: \(fault)")
        })
        
        return cell
    }

    

    func getHouseAsync(query : BackendlessDataQuery)
    {
        
        backendless.persistenceService.of(House.ofClass()).find(
            query,
            response: { ( houses : BackendlessCollection!) -> () in
                let currentPage = houses.getCurrentPage()
                
                for selector in currentPage as! [House] {
                   
                        self.hostfullnamearray.append((selector.user_id?.getProperty("first_name"))! as! String+" "+((selector.user_id?.getProperty("last_name"))! as! String))
                    
                        self.houseimagearray.append(((selector.user_id?.getProperty("objectId"))! as! String)+"/"+selector.objectId)
                    
                        self.houses.append(selector as House)
                    

                }
                
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
    }
    
    func removeallarray()
    {
        hostfullnamearray.removeAll()
        houseimagearray.removeAll()
        houses.removeAll()
    }
}