//
//  MainPageVC.swift
//  RoommateApp
//
//  Created by Alican Özsırma on 04/01/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class MainPageVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var backendless = Backendless.sharedInstance()
    var selectedhouseid = String()
    let messagelabel = UILabel()

    @IBOutlet var tableview: UITableView!
    
    var searchcity = String()
    var searchgender = String()
    var searchperson = String()
    var searchjob = String()
    var searchprice = Double()
    var searchtown = String()
    var searchnumberofad = String()
    
    var houses = [House]()
    var hostfullname = [String]()
    var houseimagearray = [String]()
    
    let refreshControl : UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    
    override func viewWillAppear(animated: Bool) {
      
        refreshControl.addTarget(self, action: #selector(MainPageVC.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.tableview.addSubview(refreshControl)
        let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector:#selector(MainPageVC.do_table_refresh), userInfo: nil, repeats: false)
        
        removeallarray()
        getHouseAsync()
        self.do_table_refresh()
       
    }
    
        func do_table_refresh()
        {
            dispatch_async(dispatch_get_main_queue(), {
                self.tableview.reloadData()
                return
            })
        }
    
    func removeallarray()
    {
        houseimagearray.removeAll()
        houses.removeAll()
    }

    
    func refresh(sender:AnyObject)
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableview.reloadData()
            return
        })
        self.refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        //messagelabel.text = "Lütfen Ekranı Aşağıya Çekerek Refresh Yapınız"
        messagelabel.textAlignment = NSTextAlignment.Center
        messagelabel.numberOfLines = 1
        messagelabel.font = UIFont(name: "Avenir-Light", size: 15)
        messagelabel.sizeToFit()
        self.tableview.backgroundView = messagelabel
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MainPageCells
        
        
        cell.houseadress.text = self.houses[indexPath.row].town!+"/"+self.houses[indexPath.row].city!;
        cell.housesize.text = self.houses[indexPath.row].aboutowner
        cell.houseprice.text = String(self.houses[indexPath.row].price)+"TL"
        cell.hostname.text = self.hostfullname[indexPath.row]
        cell.housestars.rating = Float(self.houses[indexPath.row].average);
        
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
    
   /* func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedhouseid = self.houseidarray[indexPath.row]
        
    }*/
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "DetailSegue") {
            
            let vc: UINavigationController = segue.destinationViewController as! UINavigationController
            
            let svc = vc.topViewController as! DetailHouseVC
            
            let selectedIndexPath = tableview.indexPathForSelectedRow!
            
            svc.selectedid = self.houses[selectedIndexPath.row].objectId
        }
    }
    
  
    @IBAction func signout(sender: AnyObject) {
        
            self.exitfromsystem()
        
          }
    
    internal func exitfromsystem()
    {
        
      NSUserDefaults.standardUserDefaults().removeObjectForKey("user_name")
    NSUserDefaults.standardUserDefaults().synchronize()
        
        Types.tryblock({ () -> Void in
            self.backendless.userService.logout()
            
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("ViewControllerNC") as! UINavigationController
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
            
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
        })

        
    }
 
    func getHouseAsync()
    {
    let query = BackendlessDataQuery()
    
    query.whereClause = fillwhereclause(searchcity, searchtown: searchtown, searchgender: searchgender, searchperson: searchperson, searchjob: searchjob, searchprice: searchprice,searchnumberofad: searchnumberofad)
    
        backendless.persistenceService.of(House.ofClass()).find(
            query,
                response: { ( houses : BackendlessCollection!) -> () in
                    let currentPage = houses.getCurrentPage()
    
                    for selector in currentPage as! [House] {
                        
                        if (selector.isactive != false)
                        {
                            self.hostfullname.append(((selector.user_id?.getProperty("first_name"))! as! String)+" "+((selector.user_id?.getProperty("last_name"))! as! String))
                            self.houseimagearray.append(((selector.user_id?.getProperty("objectId"))! as! String)+"/"+selector.objectId)
                            self.houses.append(selector)
                        }
                    }
                    
                    if (currentPage.count == 0)
                    {
                        self.messagelabel.text = "Bu kriterlerde ilan bulunamadı."
                    }
                    else
                    {
                        self.messagelabel.text = "Lütfen Ekranı Aşağıya Çekerek Refresh Yapınız"
                    }
            },
                error: { ( fault : Fault!) -> () in
                    print("Server reported an error: \(fault)")
            }
    )
}
}



func fillwhereclause(searchcity:String,searchtown:String,searchgender:String,searchperson:String,searchjob:String,searchprice:Double,searchnumberofad:String) -> String
{
    var whereclause = String()
    if (searchcity.isBlank == true && searchtown.isBlank == true && searchgender.isBlank == true && searchperson.isBlank == true && searchjob.isBlank == true && searchprice.isZero == true && searchnumberofad.isBlank == true)
    {
        whereclause = ""
    }
    if(searchnumberofad.isBlank != true)
    {
        if whereclause.isBlank == true
        {
            whereclause = whereclause + "numberofad = '\(searchnumberofad)'"
        }
        else
        {
            whereclause = whereclause + " and numberofad ='\(searchnumberofad)'"
        }
    }
    if(searchcity.isBlank != true)
    {
        if whereclause.isBlank == true
        {
        whereclause = whereclause + "city = '\(searchcity)'"
        }
        else
        {
        whereclause = whereclause + " and city = '\(searchcity)'"
        }
    }
    if(searchtown.isBlank != true)
    {
        if whereclause.isBlank == true
        {
        whereclause = whereclause + "town = '\(searchtown)'"
        }
        else
        {
            whereclause = whereclause + " and town = '\(searchtown)'"
        }
    }
    if (searchgender.isBlank != true)
    {
        if whereclause.isBlank == true
        {
            whereclause = whereclause + "whoissearched = '\(searchgender)'"
        }
        else
        {
            whereclause = whereclause + " and whoissearched = '\(searchgender)'"
        }
    }
    if(searchperson.isBlank != true)
    {
        if whereclause.isBlank == true
        {
            whereclause = whereclause + "numberofperson = '\(searchperson)'"
        }
        else
        {
            whereclause = whereclause + " and numberofperson = '\(searchperson)'"
        }
    }
    if(searchjob.isBlank != true)
    {
        if whereclause.isBlank == true
        {
            whereclause = whereclause + "job = '\(searchjob)'"
        }
        else
        {
            whereclause = whereclause + " and job = '\(searchjob)'"
        }
    }
    if(searchprice.isZero != true)
    {
        if whereclause.isBlank == true
        {
             whereclause = whereclause + "price < '\(searchprice)'"
        }
        else
        {
             whereclause = whereclause + " and price < '\(searchprice)'"
        }
    }
    return whereclause
}