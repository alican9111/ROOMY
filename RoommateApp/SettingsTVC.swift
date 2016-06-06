//
//  SettingsTVC.swift
//  RoommateApp
//
//  Created by Alican Özsırma on 22/12/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class SettingsTVC: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var backendless = Backendless.sharedInstance()
    
    @IBOutlet weak var profilephoto: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        profilephoto.layer.cornerRadius = 8.0
        profilephoto.clipsToBounds = true
        
        getFilesAsync()
      
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section
        {
        case 0:return 2
        case 1:return 1
        case 2:return 1
        default:return 2
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        Types.tryblock({ () -> Void in
            
            let result = self.backendless.fileService.remove("/users/"+String(self.backendless.userService.currentUser.getProperty("objectId"))+".jpeg")
            print("File has been removed: result = \(result)")
            },
                       
                       catchblock: { (exception) -> Void in
                        print("Server reported an error: \(exception as! Fault)")
            }
        )
        profilephoto.image = nil
        profilephoto.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.backendless.fileService.upload("/users/"+String(backendless.userService.currentUser.getProperty("objectId"))+".jpeg", content: UIImageJPEGRepresentation(self.profilephoto.image!.resizeToWidth(640, height: 480), 0))
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            if indexPath.row == 0 && indexPath.section == 0
            {
                //---------ProfilPhotoButton-------
                    let myPickerController = UIImagePickerController()
                    myPickerController.delegate = self
                    myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                    self.presentViewController(myPickerController, animated: true, completion: nil)
                //-------------------------------
                
            }
        
            if indexPath.row == 0 && indexPath.section == 2
            {
                let object = MainPageVC()
                object.exitfromsystem()
            }
    }

    func getFilesAsync()
    {
        self.backendless.file.listing("/users/", pattern:self.backendless.userService.currentUser.objectId+".jpeg", recursive:false,
                                      response: { ( result : BackendlessCollection!) -> () in
                                        let files = result.getCurrentPage()
                                        for file in files {
                                            
                                            dispatch_async(dispatch_get_main_queue(), {
                                                
                                                self.profilephoto.image =  UIImage(data: NSData(contentsOfURL: NSURL(string:file.publicUrl)!)!)
                                            })
                                        }},
                                      error: { ( fault : Fault!) -> () in
                                        print("Server reported an error: \(fault)")
        })
    }
    
}
