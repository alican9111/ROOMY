//
//  NewHouseTVC.swift
//  RoommateApp
//
//  Created by Alican Özsırma on 30/12/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class NewHouseTVC: UITableViewController {
    
    var backendless = Backendless.sharedInstance()
    
    //---------------FROM VC----------
    var sizeofhouse: String = ""
    var mainphoto: UIImage = UIImage()
    var photo1 : UIImage = UIImage()
    var photo2 : UIImage = UIImage()
    var photo3 : UIImage = UIImage()
    var numberofperson: String = ""
    var whoissearched: String = ""
    var job: String = ""
    var adress : String = ""
    var city : String = ""
    var town : String = ""
    var explanation : String = ""
    var price : Double = 0.0;
    var aboutowner : String = ""
    var latitude : String = ""
    var longitude : String = ""
    //-----------------------------------
    
    @IBOutlet weak var outlet1: UISwitch!
    @IBOutlet weak var outlet2: UISwitch!
    @IBOutlet weak var outlet3: UISwitch!
    @IBOutlet weak var outlet4: UISwitch!
    @IBOutlet weak var outlet5: UISwitch!
    @IBOutlet weak var outlet6: UISwitch!
    @IBOutlet weak var outlet7: UISwitch!
    @IBOutlet weak var outlet8: UISwitch!
    @IBOutlet weak var outlet9: UISwitch!
    
    func isvalue (switchobject: UISwitch) -> Bool
    {
        if (switchobject.on)
        {
            return true
        }
        else
        {
            return false
        }
    }

    @IBAction func backbutton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch(section)
        {
        case 0: return 6;
        case 1: return 3;
        default : return 0;
        }
    }

    @IBAction func savethisad(sender: AnyObject) {
        
        //------Show UIActivity-------
        let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spiningActivity.labelText = "Kaydediliyor"
        spiningActivity.detailsLabelText = "Lütfen Bekleyin"
        //-----------------------------------
        
            let user = self.backendless.userService.currentUser
            
            let myhouse = House()
            myhouse.sizeofhouse = self.sizeofhouse
            myhouse.user_id = self.backendless.userService.currentUser
            myhouse.isfurniture = self.isvalue(self.outlet1)
            myhouse.iscellar = self.isvalue(self.outlet2)
            myhouse.isbalcony = self.isvalue(self.outlet3)
            myhouse.isaircondition = self.isvalue(self.outlet4)
            myhouse.isnaturalgas = self.isvalue(self.outlet5)
            myhouse.ishotwater = self.isvalue(self.outlet6)
            myhouse.isguest = self.isvalue(self.outlet7)
            myhouse.iscigarette = self.isvalue(self.outlet8)
            myhouse.iscook = self.isvalue(self.outlet9)
            myhouse.whoissearched = self.whoissearched
            myhouse.numberofperson = self.numberofperson
            myhouse.aboutowner = self.aboutowner
            myhouse.job = self.job
            myhouse.adress = self.adress
            myhouse.town = self.town
            myhouse.city = self.city
            myhouse.isactive = true
            myhouse.explanation = self.explanation
            myhouse.price = self.price
            myhouse.latitude = latitude
            myhouse.longitude = longitude
        
            myhouse.numberofad = self.counters()
            
            let dataStore = backendless.data.of(House.ofClass())
        
        
        
            dataStore.save(myhouse,
            response: { (result: AnyObject!) -> Void in
                let house = result as! House
                
                let imagedata = UIImageJPEGRepresentation(self.mainphoto.resizeToWidth(640, height: 480), 0)
            
                
                if (imagedata != nil)
                {
                    self.backendless.fileService.upload("/homes/"+user.objectId+"/"+house.objectId+"/mainphoto.jpeg", content: imagedata)
                }
                if (self.photo1.CGImage != nil)
                {
                    let photo1data = UIImageJPEGRepresentation(self.photo1.resizeToWidth(640, height: 480), 0)
                    self.backendless.fileService.upload("/homes/"+user.objectId+"/"+house.objectId+"/photo1.jpeg", content: photo1data)

                }
                if (self.photo2.CGImage != nil)
                {
                    let photo2data = UIImageJPEGRepresentation(self.photo2.resizeToWidth(640, height: 480), 0)
                    self.backendless.fileService.upload("/homes/"+user.objectId+"/"+house.objectId+"/photo2.jpeg", content: photo2data)
                    
                }

                if (self.photo3.CGImage != nil)
                {
                    let photo3data = UIImageJPEGRepresentation(self.photo3.resizeToWidth(640, height: 480), 0)
                    self.backendless.fileService.upload("/homes/"+user.objectId+"/"+house.objectId+"/photo3.jpeg", content: photo3data)
                    
                }
                
                
                spiningActivity.hide(true)
                
                self.alertmessages("Ev ilanınınız başarıyla eklendi", titles: "Tebrikler")
                
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier("GeneralTabBarController") as UIViewController
                appDelegate.window?.rootViewController = initialViewController
                appDelegate.window?.makeKeyAndVisible()
                
                
            },
                error: { (fault: Fault!) -> Void in
                    spiningActivity.hide(true)
                self.alertmessages("Ev ilanınınız eklenemedi", titles: "Hata")
                     print("Server reported an error: \(fault)")

            })
        
    }
    
    func counters() -> String{
        var counter = String()
        Types.tryblock({ () -> Void in
            let myCounter = "test";
            if self.backendless.counters.get(myCounter) == 0 {
                let initValue = self.backendless.counters.addAndGet(myCounter, value: 10000)
                counter = String(initValue)
            } else {
                let cont = self.backendless.counters.addAndGet(myCounter, value: 1)
                counter = String(cont)
            }
            },
                       catchblock: { (exception) -> Void in
                        print("\(exception as! Fault)")
            }
        )
        return counter
    }
}

