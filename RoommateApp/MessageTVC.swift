//
//  MessageTVC.swift
//  RoommateApp
//
//  Created by Apple on 14/03/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class MessageTVC: UITableViewController {
    
    var backendless = Backendless.sharedInstance()
    let messagelabel = UILabel()
    
    var messageidarray = [String]()
    var houseimagearray = [String]()
    var hostfullnamearray = [String]()
    var hostidarray = [String]()
    var housetopicarray = [String]()
    var numberofadarray = [String]()
    var selectedrow = String()
    var refreshControlm = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Mesajlar"
        refreshControlm.addTarget(self, action: #selector(MessageTVC.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControlm)
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:#selector(MessageTVC.do_table_refresh), userInfo: nil, repeats: false)

        
        
        let query = BackendlessDataQuery()
        query.whereClause = "receiver_id.objectId = '\(backendless.userService.currentUser.getProperty("objectId"))' or sender_id.objectId = '\(backendless.userService.currentUser.getProperty("objectId"))'"
        
        //-----GET SENDER and GET RECEIVER-----------------------
        backendless.persistenceService.of(Messages.ofClass()).find(
            query,
            response: { ( messages : BackendlessCollection!) -> () in
                let currentPage = messages.getCurrentPage()
                
                if (currentPage != nil)
                {
                    
                for selector in currentPage as! [Messages] {
                    
                    if selector.sender_id.objectId == self.backendless.userService.currentUser.objectId
                    {
                        if (self.housetopicarray.contains(selector.message_topic) == false) && (self.hostidarray.contains(selector.receiver_id.objectId) == false)
                        {
                        let load_hostid = selector.receiver_id.objectId
                        let load_hostname = ((selector.receiver_id.getProperty("first_name"))! as! String)+" "+((selector.receiver_id.getProperty("last_name"))! as! String)
                        let load_houseimages = ((selector.receiver_id.getProperty("objectId"))! as! String)
                        let load_housetopic = selector.message_topic
                        let load_numberofad = selector.numberofad
                            
                        self.messageidarray.append(selector.objectId)
                        self.hostfullnamearray.append(load_hostname)
                        self.hostidarray.append(load_hostid)
                        self.houseimagearray.append(load_houseimages)
                        self.housetopicarray.append(load_housetopic)
                        self.numberofadarray.append(load_numberofad)
                        
                        }
                    }
                    else if selector.receiver_id.objectId == self.backendless.userService.currentUser.objectId
                    {
                        if (self.housetopicarray.contains(selector.message_topic) == false) && (self.hostidarray.contains(selector.receiver_id.objectId) == false)
                        {
                        let load_hostid = selector.sender_id.objectId
                        let load_hostname = ((selector.sender_id.getProperty("first_name"))! as! String)+" "+((selector.sender_id.getProperty("last_name"))! as! String)
                        let load_houseimages = ((selector.sender_id.getProperty("objectId"))! as! String)
                        let load_housetopic = selector.message_topic
                        let load_numberofad = selector.numberofad
                            
                        self.messageidarray.append(selector.objectId)
                        self.hostfullnamearray.append(load_hostname)
                        self.hostidarray.append(load_hostid)
                        self.houseimagearray.append(load_houseimages)
                        self.housetopicarray.append(load_housetopic)
                        self.numberofadarray.append(load_numberofad)

                        }
                    }
                    
                    }
                }
                if (currentPage.count == 0)
                {
                    self.messagelabel.text = "Mesaj Kutunuz Boş"
                }
                
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
        
        
        
        self.do_table_refresh()
    
    
    //print(searchcity,searchprice,searchperson,searchgender,searchjob)
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
    self.refreshControlm.endRefreshing()
}


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        //messagelabel.text = "Lütfen Ekranı Aşağıya Çekerek Refresh Yapınız"
        messagelabel.textAlignment = NSTextAlignment.Center
        messagelabel.numberOfLines = 1
        messagelabel.font = UIFont(name: "Avenir-Light", size: 15)
        messagelabel.sizeToFit()
        self.tableView.backgroundView = messagelabel
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return hostfullnamearray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MessageCell
        
        cell.hostname.text = self.hostfullnamearray[indexPath.row]
        
        cell.topic.text = self.numberofadarray[indexPath.row]

        self.backendless.file.listing("/users/", pattern:self.houseimagearray[indexPath.row]+".jpeg", recursive:false,
            response: { ( result : BackendlessCollection!) -> () in
                let files = result.getCurrentPage()
                for file in files {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        cell.profilephoto.image = (UIImage(data: NSData(contentsOfURL: NSURL(string:file.publicUrl)!)!))
                    })
                }},
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
        })
        

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ConversationSegue") {
            
            let vc: UINavigationController = segue.destinationViewController as! UINavigationController
            
            let svc = vc.topViewController as! ConversationVC
            
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            
            svc.selectedperson = self.hostidarray[selectedIndexPath.row]
            
            svc.selectedtopic = self.housetopicarray[selectedIndexPath.row]
            
            
        }
    }

}