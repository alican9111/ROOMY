//
//  ConversationVC.swift
//  RoommateApp
//
//  Created by Apple on 15/03/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class ConversationVC: UIViewController {

    
    var backendless = Backendless.sharedInstance()
    var selectedperson = String()
    var selectedtopic = String()
    
    var refreshControl = UIRefreshControl()

    @IBOutlet weak var oldmessages: UITextView!
    @IBOutlet weak var messagecontent: UITextView!
    
    @IBAction func sendmessage(sender: AnyObject) {
        
        let newmessage = Messages()
        
        newmessage.sender_id = self.backendless.userService.currentUser
        newmessage.receiver_id = self.backendless.userService.findById(self.selectedperson)
        newmessage.message_topic = selectedtopic
        newmessage.message_content = self.messagecontent.text
        
        let dataStore = self.backendless.data.of(Messages.ofClass())
        
        dataStore.save(
            newmessage,
            response: { (result: AnyObject!) -> Void in
                
                self.alertmessages("Mesajınız Gönderildi", titles: "Bilgi")
                
                self.oldmessages.text = ""
                self.messagecontent.text = ""
                self.getoldmessages()
                
            },
            error: { (fault: Fault!) -> Void in
                self.alertmessages("Mesajınız Gönderilemedi", titles: "Hata")
        })      }
    
    func refresh(sender:AnyObject)
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.view.reloadInputViews()
            return
        })
        self.refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagecontent.becomeFirstResponder()
        
        messagecontent.layer.cornerRadius = 5.0
        self.navigationItem.title = String(self.backendless.userService.findById(self.selectedperson).getProperty("first_name"))+" "+String(self.backendless.userService.findById(self.selectedperson).getProperty("last_name"))
        getoldmessages()
        
        
        
    }
    
   
    
    func getoldmessages()
    {
       
        let query = BackendlessDataQuery()
        let options = QueryOptions()
        options.sortBy(["created DESC"])
        
        
        query.whereClause = "((receiver_id.objectId = '\(selectedperson))' or sender_id.objectId = '\(backendless.userService.currentUser.objectId)') or (receiver_id.objectId = '\(backendless.userService.currentUser.objectId))' or sender_id.objectId = '\(selectedperson)')) and message_topic = '\(selectedtopic)'"
        
        query.queryOptions = options
        
        
        //-----GET SENDER-----------------------
        backendless.persistenceService.of(Messages.ofClass()).find(
            query,
            response: { ( messages : BackendlessCollection!) -> () in
                let currentPage = messages.getCurrentPage()
                
                
                if (currentPage != nil)
                {
                    for selector in currentPage as! [Messages] {
                        
                        if (selector.receiver_id.objectId == self.backendless.userService.currentUser.objectId)
                        {
                            self.oldmessages.text = self.oldmessages.text+self.navigationItem.title!+": "+String(UTF8String: selector.message_content)!+"\n\n"
                            
                        }
                        else if (selector.sender_id.objectId == self.backendless.userService.currentUser.objectId)
                        {
                            self.oldmessages.text = self.oldmessages.text+"Ben: "+String(UTF8String: selector.message_content)!+"\n\n"
                        }
                    }
                }
                
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backbutton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
