//
//  SendMessageVC.swift
//  RoommateApp
//
//  Created by Apple on 14/03/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class SendMessageVC: UIViewController,UITextViewDelegate {
    
    var receiver = String()
    var selectedhouseid = String()
    var v_numberofad = String()
    
    var backendless = Backendless.sharedInstance()
    @IBOutlet weak var messagecontent: UITextView!
    @IBOutlet weak var oldmessages: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        messagecontent.becomeFirstResponder()
        
        messagecontent.layer.cornerRadius = 5.0
        self.navigationItem.title = String(self.backendless.userService.findById(self.receiver).getProperty("first_name"))+" "+String(self.backendless.userService.findById(self.receiver).getProperty("last_name"))
        getoldmessages()
        
            
        

        // Do any additional setup after loading the view.
    }
    
    
 
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func donebutton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sendmessage(sender: AnyObject) {
        
        let query = BackendlessDataQuery();
        query.whereClause = "objectId = '\(selectedhouseid)'"
        
        let newmessage = Messages()
        
        newmessage.sender_id = self.backendless.userService.currentUser
        newmessage.receiver_id = self.backendless.userService.findById(self.receiver)
        newmessage.message_topic = selectedhouseid
        newmessage.message_content = self.messagecontent.text
        
        //-------------------House Class Find NumberofAD------
        let housequery = BackendlessDataQuery()
        housequery.whereClause = "objectId = '\(selectedhouseid)'"
        let housedatastore = self.backendless.data.of(House.ofClass())
        
        housedatastore.find(housequery,
            response: { (result: BackendlessCollection!) -> Void in
                let contacts = result.getCurrentPage() as! [House]
                print(contacts.count)
                for selector in contacts {
                    self.v_numberofad = selector.numberofad
                }
            },
            error: { (fault: Fault!) -> Void in
                print("Server reported an error: \(fault)")
        })
        
        //----------------------------------------------------
        newmessage.numberofad = v_numberofad
        
        print(selectedhouseid)
        print(newmessage.numberofad)
        
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
        })        
        
    }
    
    
    func getoldmessages()
    {
        
        let query = BackendlessDataQuery()
        let options = QueryOptions()
        options.sortBy(["created DESC"])
        
        
        query.whereClause = "((receiver_id.objectId = '\(receiver))' or sender_id.objectId = '\(backendless.userService.currentUser.objectId)') or (receiver_id.objectId = '\(backendless.userService.currentUser.objectId))' or sender_id.objectId = '\(receiver)')) and message_topic = '\(selectedhouseid)'"
        
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


}
