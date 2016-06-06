//
//  UpdateProfileVC.swift
//  RoommateApp
//
//  Created by Apple on 08/03/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class UpdateProfileVC: UIViewController,UIAlertViewDelegate,UIPickerViewDelegate,UITextFieldDelegate {
    
    var backendless = Backendless.sharedInstance()

    @IBOutlet weak var updatebutton: UIButton!
    @IBOutlet weak var textphone: UITextField!
    @IBOutlet weak var phonelabel: UILabel!
    @IBOutlet weak var citylabel: UILabel!
    @IBOutlet weak var textcity: UITextField!
    @IBOutlet weak var joblabel: UILabel!
    @IBOutlet weak var segmentjob: UISegmentedControl!
    var currentusercity = String()
    var currentuserjob = String()
    var currentuserphone = String()
    var cities = [String]()
    
    var citiespickerview = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        
        findCurrentUserAsync()
        getCitiesAsyc()
        
        citiespickerview.delegate = self
        
        textcity.inputView = citiespickerview
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.tintColor = UIColor.blackColor()
        let toolbarbutton = UIBarButtonItem(title: "Bitti", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SignUpVC.donePicker))
        
        toolbar.setItems([toolbarbutton], animated: false)
        toolbar.userInteractionEnabled = true

        textcity.inputAccessoryView = toolbar
        
        textcity.text = currentusercity
        
        print(currentusercity)
        
    }
 
    @IBAction func updateprofil(sender: AnyObject) {
        confirmmessagesforwiew("Bilgileriniz Güncelleştirilecek?", titles: "Onay", delegate: self)
    }
    
    
    //----------Picker-View----------
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return cities.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return cities[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        textcity.text = cities[row]
    }
    func donePicker() {
        textcity.resignFirstResponder()
    }
    //-------------------------------

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backbutton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        if alertView.message == "Bilgileriniz Güncelleştirilecek?"
        {
            if buttonIndex == 1
            {
               updateProfileAsync()
            }
        }
    }
    
    func findCurrentUserAsync() {
        let query = BackendlessDataQuery()
        query.whereClause = "objectId = '\(backendless.userService.currentUser.objectId)'"
        
        let dataStore = backendless.data.of(BackendlessUser.ofClass())
        
        //------Show UIActivity-------
        let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spiningActivity.labelText = "Profiliniz Yükleniyor"
        spiningActivity.detailsLabelText = "Lütfen Bekleyin"
        //-----------------------------------
        
        dataStore.find(query,
            response: { (result: BackendlessCollection!) -> Void in
                let results = result.getCurrentPage()
                for obj in results as! [BackendlessUser]{
                    if obj.getProperty("job") as! String == "Öğrenci"
                    {
                        self.segmentjob.selectedSegmentIndex = 0
                        self.currentuserjob = self.segmentjob.titleForSegmentAtIndex(0)!
                    }
                    else{
                        self.segmentjob.selectedSegmentIndex = 1
                         self.currentuserjob = self.segmentjob.titleForSegmentAtIndex(1)!
                    }
                    self.textcity.text = obj.getProperty("city") as? String
                    self.textphone.text = obj.getProperty("phone") as? String
                    self.currentusercity = self.textcity.text!
                    self.currentuserphone = self.textphone.text!
                
                }
                spiningActivity.hide(true)
            },
            error: { (fault: Fault!) -> Void in
                print("Server reported an error: \(fault)")
        })
    }
    
    //--------Keyboard Control----------
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    //-------------------------------------
    
    func getCitiesAsyc()
    {
        
        //---GET CITIES----------
        let query = BackendlessDataQuery()
        let options = QueryOptions()
        options.sortBy(["name ASC"])
        query.queryOptions = options
        let dataStore = backendless.data.of(Cities.ofClass())
        
        dataStore.find(query,
                       response: { (result: BackendlessCollection!) -> Void in
                        let results = result.getCurrentPage()
                        for selector in results {
                            self.cities.append(selector.name)
                        }
            },
                       error: { (fault: Fault!) -> Void in
                        print("Server reported an error: \(fault)")
        })
    }
    
    func updateProfileAsync() {
        var updatedprofile = BackendlessUser()
       let dataStore = Backendless.sharedInstance().data.of(BackendlessUser.ofClass())
    
        updatedprofile = self.backendless.data.of(BackendlessUser.ofClass()).findID(backendless.userService.currentUser.objectId) as! BackendlessUser
        updatedprofile.objectId = backendless.userService.currentUser.objectId
        updatedprofile.setProperty("city", object: self.textcity.text)
        updatedprofile.setProperty("phone", object: self.textphone.text)
        updatedprofile.setProperty("job", object: self.segmentjob.titleForSegmentAtIndex(self.segmentjob.selectedSegmentIndex))
        
                            dataStore.save(
                                updatedprofile,
                                response: { (result: AnyObject!) -> Void in
                                    let updated = result as! BackendlessUser
                                    print("Contact has been updated: \(updated.objectId)")
                                },
                                error: { (fault: Fault!) -> Void in
                                    print("Server reported an error (2): \(fault)")
                            })
        
    }

}
