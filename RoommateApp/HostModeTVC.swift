//
//  HostModeTVC.swift
//  RoommateApp
//
//  Created by Alican Özsırma on 22/12/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class HostModeTVC: UITableViewController, UIAlertViewDelegate {
    
    var backendless = Backendless.sharedInstance()
    var houseimagearray = [String]()
    var sendertag = Int()
    var houses = [House]()
    let refreshControl2 = UIRefreshControl()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        refreshControl2.addTarget(self, action: #selector(HostModeTVC.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:#selector(HostModeTVC.do_table_refresh), userInfo: nil, repeats: false)
        self.tableView.addSubview(refreshControl2)

        getMyHouseAsync()
        
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
        self.refreshControl2.endRefreshing()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        if alertView.message == "İlanınız Aktif Olucak?"
        {
            if buttonIndex == 1
            {
                print(houses[sendertag].objectId)
                updateStatusAsync(houses[sendertag].objectId,status: true)
            }
        }
        else if alertView.message == "İlanınız Pasif Olucak?"
        {
            if buttonIndex == 1
            {
                print(houses[sendertag].objectId)
                updateStatusAsync(houses[sendertag].objectId,status: false)
            }
        }
    }
    
    @IBAction func valuechangedactive(sender: UISwitch) {
        if (sender.on == true)
        {
           confirmmessages("İlanınız Aktif Olucak?", titles: "Bilgi",delegate: self)
            sendertag = sender.tag
        }
        else if(sender.on == false)
        {
            confirmmessages("İlanınız Pasif Olucak?", titles: "Bilgi",delegate : self)
            sendertag = sender.tag
        }
    }
    
  
    @IBAction func backbutton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return houses.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! HostModeCells
        
        
        cell.houseadress.text = self.houses[indexPath.row].town!+"/"+self.houses[indexPath.row].city!
        cell.housesize.text = self.houses[indexPath.row].sizeofhouse
        cell.houseprice.text = String(self.houses[indexPath.row].price)+"TL"
        cell.houseid.text = self.houses[indexPath.row].objectId
        
       
        if (self.houses[indexPath.row].isactive == true)
        {
            cell.active.setOn(true, animated: true)
            cell.active.tag = indexPath.row
        }
        else
        {
            cell.active.setOn(false, animated: true)
            cell.active.tag = indexPath.row
        }
        
        
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
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete)
        {
            let removehouse = House()
            removehouse.objectId = houses[indexPath.row].objectId
            
            houses.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
            
            let dataStore = backendless.data.of(House.ofClass())

                    // now delete the saved object
                    dataStore.remove(
                        removehouse,
                        response: { (result: AnyObject!) -> Void in
                            print("Contact has been deleted: \(result)")
                        },
                        error: { (fault: Fault!) -> Void in
                            print("Server reported an error (2): \(fault)")
                    })
        }
    }
    
    func getMyHouseAsync()
    {
        let query = BackendlessDataQuery()
        query.whereClause = "user_id.objectId='\(backendless.userService.currentUser.objectId)'"
        backendless.persistenceService.of(House.ofClass()).find(query,
                    response: { ( houses : BackendlessCollection!) -> () in
                        let currentPage = houses.getCurrentPage()
                                                                    
                        for selector in currentPage as! [House] {
                            
                            self.houses.append(selector)
                            
                            let load_houseimages = ((selector.user_id?.getProperty("objectId"))! as! String)+"/"+selector.objectId

                            self.houseimagearray.append(load_houseimages)
                                                                        
                }
                                                                    
            },
                error: { ( fault : Fault!) -> () in
                        self.alertmessages("Beklenmeyen bir hata oluştu.Uygulamayı Yeniden Başlatın", titles: "Hata")
            }
        )
    }
    
    func updateStatusAsync(selectedhouseid:String,status: NSNumber) {
        var myhouse = House()
        let dataStore = Backendless.sharedInstance().data.of(House.ofClass())
        
        myhouse = backendless.data.of(House.ofClass()).findID(selectedhouseid) as! House
        myhouse.objectId = selectedhouseid
        myhouse.isactive = status
        
                    dataStore.save(
                        myhouse,
                        response: { (result: AnyObject!) -> Void in
                            let updatedHouse = result as! House
                            print("Contact has been updated: \(updatedHouse.objectId)")
                        },
                        error: { (fault: Fault!) -> Void in
                            print("Server reported an error (2): \(fault)")
                    })
    }
}
