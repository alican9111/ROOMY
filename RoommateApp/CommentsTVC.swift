//
//  CommentsTVC.swift
//  RoommateApp
//
//  Created by Alican Özsırma on 11/04/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class CommentsTVC: UITableViewController {
    
    var backendless = Backendless.sharedInstance()
    let refreshControl3 : UIRefreshControl = UIRefreshControl()
    
    var house_id : String = ""
    
    var profileimagearray = [String]()
    var hostfullnamearray = [String]()
    var housecommentarray = [String]()

    @IBAction func backbutton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func newcomment(sender: AnyObject) {
        
        
        var tField: UITextField!
        
        func configurationTextField(textField: UITextField!)
        {
            textField.placeholder = "Yorumunuz"
            tField = textField
        }
        
        
        func handleCancel(alertView: UIAlertAction!)
        {
            print("Cancelled !!")
        }
        
        let alert = UIAlertController(title: "Yorum Yap", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: "Vazgeç", style: UIAlertActionStyle.Cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Tamamla", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
            
            let mycomment = Comments()
            mycomment.comment = tField.text!
            mycomment.user_id = self.backendless.userService.currentUser
            mycomment.house_id = self.house_id
            
            let dataStore = self.backendless.data.of(Comments.ofClass())
            
            
            dataStore.save(mycomment,
                response: { (result: AnyObject!) -> Void in
                    
                    self.dismissViewControllerAnimated(true, completion: {
                        self.alertmessages("Yorumunuz başarıyla eklendi", titles: "Tebrikler")
                    })
                    
                    
                    
                    
                    
                    
                },
                error: { (fault: Fault!) -> Void in
             
                    self.alertmessages("Yorumunuz eklenemedi", titles: "Hata")
                    print("Server reported an error: \(fault)")
                    
            })

            
        }))
        self.presentViewController(alert, animated: true, completion: {
        })

        
            }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl3.addTarget(self, action: #selector(CommentsTVC.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl3)
        let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:#selector(CommentsTVC.do_table_refresh), userInfo: nil, repeats: false)
        
        getCommentsAsync()
        
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
        self.refreshControl3.endRefreshing()
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
        return housecommentarray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentsCell

        cell.fullname.text = self.hostfullnamearray[indexPath.row]
        cell.comment.text = self.housecommentarray[indexPath.row]
        
        //-----Radius image
        let imageViewSize = 70 as CGFloat
        cell.profilephoto.frame.size.height = imageViewSize
        cell.profilephoto.frame.size.width = imageViewSize
        cell.profilephoto.layer.cornerRadius = 8.0
        cell.profilephoto.clipsToBounds = true
        //-------------------
        
        self.backendless.file.listing("/users/", pattern:self.profileimagearray[indexPath.row]+".jpeg", recursive:false,
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
    
    func getCommentsAsync()
    {
        let query = BackendlessDataQuery()
        
        query.whereClause = "house_id = '\(house_id)'"
        
        backendless.persistenceService.of(Comments.ofClass()).find(
            query,
            response: { ( houses : BackendlessCollection!) -> () in
                let currentPage = houses.getCurrentPage()
                
                for selector in currentPage as! [Comments] {
                
                    let load_hostname = ((selector.user_id.getProperty("first_name"))! as! String)+" "+((selector.user_id.getProperty("last_name"))! as! String)
                    let load_comment = selector.comment
                    let load_profileimages = ((selector.user_id.getProperty("objectId"))! as! String)
                
                        self.hostfullnamearray.append(load_hostname)
                        self.housecommentarray.append(load_comment)
                        self.profileimagearray.append(load_profileimages)
                    
 
                }
                
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
    }
}



