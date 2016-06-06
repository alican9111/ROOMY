//
//  DetailHouseVC.swift
//  RoommateApp
//
//  Created by Apple on 07/03/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class DetailHouseVC: UIViewController {
    
    var backendless = Backendless.sharedInstance()
    
    //------FROM MAIN PAGE--------------
    var selectedid = String()
    var showprofile = String()
    var map = Bool()
    //----------------------------------
    
    @IBOutlet weak var floatRatingView: FloatRatingView!
    
    @IBOutlet weak var hostname: UILabel!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var explanation: UILabel!
    @IBOutlet weak var howmanyperson: UILabel!
    @IBOutlet weak var whosearched: UILabel!
    @IBOutlet weak var job: UILabel!
    @IBOutlet weak var housesize: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var likecounter: UILabel!
  
    @IBOutlet weak var isfurniture: UIImageView!
    @IBOutlet weak var iscellar: UIImageView!
    @IBOutlet weak var isbalcony: UIImageView!
    @IBOutlet weak var isaircondition: UIImageView!
    @IBOutlet weak var isnaturalgas: UIImageView!
    @IBOutlet weak var ishotwater: UIImageView!
    @IBOutlet weak var isguest: UIImageView!
    @IBOutlet weak var iscigarette: UIImageView!
    @IBOutlet weak var iscook: UIImageView!
    
    @IBOutlet weak var mainphoto: UIImageView!
    @IBOutlet weak var photo1: UIImageView!
    @IBOutlet weak var photo2: UIImageView!
    @IBOutlet weak var photo3: UIImageView!
    
    @IBOutlet weak var likeoutlet: UIBarButtonItem!
    var tag : Int = 0
    
    func showlikecount() -> Float?
    {
        var totalnumber : Double = 0
        var totalscore : Double = 0
        let query1 = BackendlessDataQuery()
        query1.whereClause = "house_id = '\(selectedid)'"
        
        let dataStore = backendless.data.of(Likes.ofClass())
        var error: Fault?
        
        let result = dataStore.findFault(&error)
        if error == nil {
            let alllikes = result.getCurrentPage()
            for selector in alllikes  as! [Likes]{
                if selector.house_id == selectedid
                {
                    
                    totalnumber += 1
                    totalscore += Double(selector.score)
                }
            }
        }
        else {
            print("Server reported an error: \(error)")
        }
        
        if let totalpeople : Double = totalnumber
        {
            likecounter.text = "("+String(Int(totalpeople))+")"
        }
        
        return Float(totalscore/totalnumber)
    }
    
    
    func likecounting()
    {
        var totalnumber : Double = 0
        var totalscore : Double = 0
        let query1 = BackendlessDataQuery()
        query1.whereClause = "house_id = '\(selectedid)'"
        
        let dataStore = backendless.data.of(Likes.ofClass())
        var error: Fault?
        
        let result = dataStore.findFault(&error)
        if error == nil {
            let alllikes = result.getCurrentPage()
            for selector in alllikes  as! [Likes]{
                if selector.house_id == selectedid
                {
                    
                    totalnumber += 1
                    totalscore += Double(selector.score)
                }
            }
        }
        else {
            print("Server reported an error: \(error)")
        }
        
        if let totalpeople : Double = totalnumber
        {
            likecounter.text = "("+String(Int(totalpeople))+")"
        }
    }
   /* func tap(sender: UITapGestureRecognizer)
    {
        tag=tag+1
        if tag % 2 == 0 {
        sender.view!.delete(sender)
        }
        else
        {
        self.view.addSubview(mainphoto)
        }
            //sender.view?.removeFromSuperview()
        
        print("a")
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likecounting()
       
       /* var tapgesture = UITapGestureRecognizer(target: self,action: Selector("tap:"))
        tapgesture.numberOfTapsRequired = 1
        mainphoto.addGestureRecognizer(tapgesture)*/
        
        
        
        
        //------star
        // Required float rating view params
        self.floatRatingView.emptyImage = UIImage(named: "StarEmpty")
        self.floatRatingView.fullImage = UIImage(named: "StarFull")
        // Optional params
        self.floatRatingView.contentMode = UIViewContentMode.ScaleAspectFit
        self.floatRatingView.maxRating = 5
        self.floatRatingView.minRating = 1
        self.floatRatingView.rating = 2.5
        self.floatRatingView.editable = true
        self.floatRatingView.halfRatings = true
        self.floatRatingView.floatRatings = false
        
        //-----
       mainphoto.layer.cornerRadius = 5.0
        photo1.layer.cornerRadius = 5.0
        photo2.layer.cornerRadius = 5.0
        photo3.layer.cornerRadius = 5.0
       mainphoto.clipsToBounds = true
        photo1.clipsToBounds = true
        photo2.clipsToBounds = true
        photo3.clipsToBounds = true
        
        if map == true
        {
            self.navigationItem.leftBarButtonItems?.removeAll()
        }
        
        //------Show UIActivity-------
        let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spiningActivity.labelText = "Ev Yükleniyor"
        spiningActivity.detailsLabelText = "Lütfen Bekleyin"
        //-----------------------------------
       
        
        
    
        let query = BackendlessDataQuery()
        query.whereClause = "objectId = '\(selectedid)'"
        backendless.data.of(House.ofClass()).find(
            query,
            response: { ( houses : BackendlessCollection!) -> () in
                let currentPage = houses.getCurrentPage()
                
                for selector in currentPage as! [House] {
                    
                    self.hostname.text = ((selector.user_id?.getProperty("first_name"))! as! String)+" "+((selector.user_id?.getProperty("last_name"))! as! String)
                    
                    self.adress.text = String(selector.adress)+" "+(selector.town! as String)+"/"+(selector.city! as String)
                    
                    self.housesize.text = selector.sizeofhouse
                    
                    self.price.text = String(selector.price)+"TL"
                    
                    self.howmanyperson.text = selector.numberofperson
                    
                    self.whosearched.text = selector.whoissearched
                    
                    self.job.text = selector.job
                    
                    self.explanation.text = selector.explanation
                    
                    self.floatRatingView.rating = Float(selector.average)
                    
                    self.checkimage(self.isfurniture,value: selector.isfurniture)
                    self.checkimage(self.isguest,value: selector.isguest)
                     self.checkimage(self.ishotwater,value: selector.ishotwater)
                     self.checkimage(self.isnaturalgas,value: selector.isnaturalgas)
                     self.checkimage(self.isaircondition,value: selector.isaircondition)
                     self.checkimage(self.iscellar,value: selector.iscellar)
                     self.checkimage(self.isbalcony,value: selector.isbalcony)
                     self.checkimage(self.iscigarette,value: selector.iscigarette)
                    self.checkimage(self.iscook,value: selector.iscook)
                    
                    self.showprofile = (selector.user_id?.objectId)!
                    
                    
                    self.backendless.file.listing("/homes/"+(selector.user_id?.objectId)!+"/"+self.selectedid, pattern:"*.jpeg", recursive:false,
                        response: { ( result : BackendlessCollection!) -> () in
                            let files = result.getCurrentPage()
                            for file in files {
                                
                                if (file.name == "mainphoto.jpeg")
                                {
                                
                                    dispatch_async(dispatch_get_main_queue(), {
                                        
                                        self.mainphoto.image =  UIImage(data: NSData(contentsOfURL: NSURL(string:file.publicUrl)!)!)
                                    })
                                }
                                else if (file.name == "photo1.jpeg")
                                {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        
                                        self.photo1.image =  UIImage(data: NSData(contentsOfURL: NSURL(string:file.publicUrl)!)!)
                                    })
                                }
                                else if (file.name == "photo2.jpeg")
                                {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        
                                        self.photo2.image =  UIImage(data: NSData(contentsOfURL: NSURL(string:file.publicUrl)!)!)
                                    })
                                }
                                else if (file.name == "photo3.jpeg")
                                {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        
                                        self.photo3.image =  UIImage(data: NSData(contentsOfURL: NSURL(string:file.publicUrl)!)!)
                                    })
                                }
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
        
    }
    
    
    func checkimage(sender: UIImageView,value: NSNumber)
    {
        if (value == true)
        {
            sender.image = UIImage(named: "yes")
        }
        else
        {
            sender.image = UIImage(named: "no")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backbutton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ProfileSegue") {
            
            let vc: UINavigationController = segue.destinationViewController as! UINavigationController
            
            let svc = vc.topViewController as! ShowProfileVC
            
            svc.showprofileid = showprofile
            
            svc.selectedhouseid = selectedid
            
            
        }
        else if (segue.identifier == "CommentSegue")
        {
            let vc: UINavigationController = segue.destinationViewController as! UINavigationController
            
            let svc = vc.topViewController as! CommentsTVC
            
            svc.house_id = selectedid
            
        }
    }
    
    
    
    @IBAction func likebutton(sender: AnyObject) {
        
        if showprofile == backendless.userService.currentUser.objectId
        {
            likeoutlet.enabled = false
        }
        else if floatRatingView.rating == 0
        {
            alertmessages("Lütfen Yıldız Puanı Veriniz", titles: "Bilgi")
        }
        else
        {
            
            let query1 = BackendlessDataQuery()
            let query2 = BackendlessDataQuery()
            query1.whereClause = "house_id = '\(selectedid)'"
            query2.whereClause = "house_id = '\(selectedid)' and liked_id.objectId = '\(backendless.userService.currentUser.objectId)'"
            
            let dataStore = backendless.data.of(Likes.ofClass())
            let dataStore2 = backendless.data.of(House.ofClass())
            
            
            dataStore.find(query1,
                response: { (result: BackendlessCollection!) -> Void in
                    let results = result.getCurrentPage()
                    
                    if results.count == 0
                    {
                        let newlike = Likes()
                        
                        newlike.house_id = self.selectedid
                        newlike.liked_id = self.backendless.userService.currentUser
                        newlike.score = Double(self.floatRatingView.rating)
                        
                        // save object asynchronously
                        dataStore.save(
                            newlike,
                            response: { (result: AnyObject!) -> Void in
                                self.alertmessages("Puanınız Eklendi", titles: "Puan Ver")
                                                          },
                            error: { (fault: Fault!) -> Void in
                                print("fServer reported an error: \(fault)")
                        })
                        
                        var existhouse = House()
                        
                        existhouse = self.backendless.data.of(House.ofClass()).findID(self.selectedid) as! House
                        existhouse.objectId = self.selectedid
                        existhouse.average = Double(self.floatRatingView.rating)
                        
                        dataStore2.save(
                            existhouse,
                            response: { (result: AnyObject!) -> Void in
                                print("Puanınız eve Eklendi")
                            },
                            error: { (fault: Fault!) -> Void in
                                print("fServer reported an error: \(fault)")
                        })
                        
                    }
                    else{
                        
                        dataStore.find(query2,response: { (result : BackendlessCollection!) -> Void in
                        let results = result.getCurrentPage()
                            
                            if results.count > 0
                            {
                                self.alertmessages("Bu ilana puan vermişsiniz", titles: "İşlem")
                            }
                            else if results.count == 0
                            {
                                let newlike = Likes()
                                
                                newlike.house_id = self.selectedid
                                newlike.liked_id = self.backendless.userService.currentUser
                                newlike.score = Double(self.floatRatingView.rating)
                                
                                
                            
                                dataStore.save(
                                    newlike,
                                    response: { (result: AnyObject!) -> Void in
                                        self.alertmessages("Puanınız Eklendi", titles: "Puan Ver")
                                       
                                    },
                                    error: { (fault: Fault!) -> Void in
                                        print("fServer reported an error: \(fault)")
                                })
                                }
                            },error: { (fault: Fault!) -> Void in
                                print("Server reported an error: \(fault)")})
                    //
                        
                        var existhouse = House()
                        
                        existhouse = self.backendless.data.of(House.ofClass()).findID(self.selectedid) as! House
                        existhouse.objectId = self.selectedid
                        existhouse.average = Double(self.showlikecount()!)
                        
                        dataStore2.save(
                            existhouse,
                            response: { (result: AnyObject!) -> Void in
                                print("Puanınız eve 2.ci Eklendi")
                            },
                            error: { (fault: Fault!) -> Void in
                                print("fServer reported an error: \(fault)")
                        })

                        
                    }
                },
                error: { (fault: Fault!) -> Void in
                    print("Server reported an error: \(fault)")
            })
    }
    }

}
