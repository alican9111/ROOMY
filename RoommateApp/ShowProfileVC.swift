//
//  ShowProfileVC.swift
//  RoommateApp
//
//  Created by Apple on 08/03/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class ShowProfileVC: UIViewController {
    
    var backendless = Backendless.sharedInstance()
    var showprofileid = String()
    var selectedhouseid = String()
    
    @IBOutlet weak var profilephoto: UIImageView!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var job: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var birthdate: UILabel!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        profilephoto.layer.cornerRadius = 8.0
        profilephoto.clipsToBounds = true
        
        //------Show UIActivity-------
        let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spiningActivity.labelText = "Profil Yükleniyor"
        spiningActivity.detailsLabelText = "Lütfen Bekleyin"
        //-----------------------------------

        
        let query = BackendlessDataQuery()
        query.whereClause = "objectId = '\(showprofileid)'"
        backendless.data.of(BackendlessUser.ofClass()).find(
            query,
            response: { ( houses : BackendlessCollection!) -> () in
                let currentPage = houses.getCurrentPage()
                
                for selector in currentPage as! [BackendlessUser] {
                    
                    if (String(selector.getProperty("objectId")) == String(self.backendless.userService.currentUser.getProperty("objectId")))
                    {
                        self.navigationItem.rightBarButtonItem?.enabled = false
                    }
                    
                    self.navigationItem.title = ((selector.getProperty("first_name"))! as! String)+" "+((selector.getProperty("last_name"))! as! String)
                    
                    self.gender.text = String(selector.getProperty("gender"))
                    
                    self.job.text = String(selector.getProperty("job"))
                    
                    self.email.text = String(selector.getProperty("email"))
                    
                    self.phone.text = String(selector.getProperty("phone"))
                    
                    self.birthdate.text = String(selector.getProperty("birth_date"))
                    
                    self.city.text = String(selector.getProperty("city"))
                    
                    self.backendless.file.listing("/users/", pattern:"\(self.showprofileid).jpeg", recursive:false,
                        response: { ( result : BackendlessCollection!) -> () in
                            let files = result.getCurrentPage()
                            for file in files {
                                    
                                    dispatch_async(dispatch_get_main_queue(), {
                                        
                                        self.profilephoto.image =  UIImage(data: NSData(contentsOfURL: NSURL(string:file.publicUrl)!)!)
                                    })
                                
                                spiningActivity.hide(true)
                                }
                        },
                        error: { ( fault : Fault!) -> () in
                            print("Server reported an error: \(fault)")
                    })
                }
                
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
        
        let phoneNumber: String = "tel://".stringByAppendingString(phone.text!) // titleLabel.text has the phone number.
        UIApplication.sharedApplication().openURL(NSURL(string:phoneNumber)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backbutton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "MessageSegue") {
            
            let vc: UINavigationController = segue.destinationViewController as! UINavigationController
            
            let svc = vc.topViewController as! SendMessageVC
            
            svc.receiver = showprofileid
            
            svc.selectedhouseid = selectedhouseid
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
