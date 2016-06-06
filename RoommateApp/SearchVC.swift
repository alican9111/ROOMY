//
//  SearchVC.swift
//  RoommateApp
//
//  Created by Apple on 28/01/16.
//  Copyright © 2016 mac. All rights reserved.
//

import UIKit

class SearchVC: UIViewController, UIPickerViewDelegate,UITextFieldDelegate {

    var backendless  = Backendless.sharedInstance()
    var objectid = String()
    var returngender = String ()
    var returnperson = String ()
    var returnjob = String()
    var cities = [String]()
    var towns = [String]()
    var citiespickerview = UIPickerView()
    var townspickerview = UIPickerView()
    
    @IBOutlet weak var numberofad: UITextField!
    @IBOutlet weak var towntext: UITextField!
    @IBOutlet weak var citytext: UITextField!
    @IBOutlet weak var segmentgender: UISegmentedControl!
    @IBOutlet weak var segmentperson: UISegmentedControl!
    @IBOutlet weak var segmentjob: UISegmentedControl!
    @IBOutlet weak var price: UISlider!
    @IBOutlet weak var pricelabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCitiesAsync()
        
        pricelabel.text = String(Int(price.value)) + " TL kadar"
        
        citiespickerview.delegate = self
        townspickerview.delegate = self
        citytext.inputView = citiespickerview
        towntext.inputView = townspickerview
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.tintColor = UIColor.blackColor()
        
        let toolbarbutton = UIBarButtonItem(title: "Bitti", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SearchVC.donePicker))
        
        toolbar.setItems([toolbarbutton], animated: false)
        toolbar.userInteractionEnabled = true
        
        citytext.inputAccessoryView = toolbar
        towntext.inputAccessoryView = toolbar
        
    }
    
    @IBAction func valuechangedcity(sender: AnyObject) {
        towns.removeAll()
        getCitiesDistrictsAsync()
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
    
    func donePicker(){
        citytext.resignFirstResponder()
        towntext.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backbutton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func pricechanged(sender: AnyObject) {
        pricelabel.text = String(Int(price.value)) + " TL kadar"
    }
    
    //----------Picker-View----------
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
   func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
    if (pickerView==citiespickerview)
            {
                return cities.count
            }
    else if(pickerView==townspickerview){
        return towns.count
    }
    return 0
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if(pickerView==citiespickerview)
        {
            return cities[row]
        }
        else if(pickerView==townspickerview){
            return towns[row]
        }
       return ""
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(pickerView==citiespickerview)
        {
            citytext.text = cities[row]
        }
        else if (pickerView==townspickerview)
        {
            if (towns.count != 0)
            {
                towntext.text = towns[row]
            }
        }
    }
    //-------------------------------
    
    //-----Prepare Segue---------
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "SearchSegue") {
            
            let vc: UITabBarController = segue.destinationViewController as! UITabBarController
            
            let nav = vc.viewControllers![0] as! UINavigationController
            
            let svc = nav.topViewController as! MainPageVC
            
                svc.searchcity = citytext.text!
                svc.searchtown = towntext.text!
                svc.searchgender = returngender
                svc.searchperson = returnperson
                svc.searchjob = returnjob
                svc.searchprice = Double(Int(price.value))
                svc.searchnumberofad = numberofad.text!
            
        }
    }
//-------------------------------
    
    
    @IBAction func actiongender(sender: AnyObject) {
        switch sender.selectedSegmentIndex
        {
        case 0:returngender = "Bay"
        case 1:returngender = "Bayan"
        default:returngender = ""
        }
    }
    
    @IBAction func actionperson(sender: AnyObject) {
        switch sender.selectedSegmentIndex
        {
        case 0:returnperson = "1"
        case 1:returnperson = "2"
        case 2:returnperson = "3+"
        default:returnperson = ""
        }
    }
    
    @IBAction func actionjob(sender: AnyObject) {
        switch sender.selectedSegmentIndex{
        case 0:returnjob = "Öğrenci"
        case 1:returnjob = "Diğer"
        default:returnjob = ""
        }
    }
    
    
    @IBAction func allclearbutton(sender: AnyObject) {
        citytext.text = ""
        towntext.text = ""
        numberofad.text = ""
        
        segmentjob.selectedSegmentIndex = UISegmentedControlNoSegment
        segmentgender.selectedSegmentIndex = UISegmentedControlNoSegment
        segmentperson.selectedSegmentIndex = UISegmentedControlNoSegment
        price.setValue(250, animated: true)
        pricelabel.text = "250 TL Kadar"
    }
    
    func getCitiesAsync()
    {
        let query = BackendlessDataQuery()
        let options = QueryOptions()
        options.sortBy(["name ASC"])
        query.queryOptions = options
        let dataStore = backendless.data.of(Cities.ofClass())
        
        //------Show UIActivity-------
        let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spiningActivity.labelText = "Şehirler Yükleniyor"
        spiningActivity.detailsLabelText = "Lütfen Bekleyin"
        //-----------------------------------
        
        dataStore.find(query,
                       response: { (result: BackendlessCollection!) -> Void in
                        let results = result.getCurrentPage()
                        for selector in results {
                            self.cities.append(selector.name)
                        }
                        spiningActivity.hide(true)
            },
                       error: { (fault: Fault!) -> Void in
                        print("Server reported an error: \(fault)")
        })
    }
    
    func getCitiesDistrictsAsync()
    {
        let query1 = BackendlessDataQuery()
        let query2 = BackendlessDataQuery()
        query1.whereClause = "name = '\(citytext.text! as String)'"
        
        let dataStore1 = backendless.data.of(Cities.ofClass())
        let dataStore2 = backendless.data.of(Districts.ofClass())
        //------Show UIActivity-------
        let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spiningActivity.labelText = "İlçeler Yükleniyor"
        spiningActivity.detailsLabelText = "Lütfen Bekleyin"
        //-----------------------------------
        dataStore1.find(query1,
                        response: { (result: BackendlessCollection!) -> Void in
                            let results = result.getCurrentPage()
                            
                            for selector in results as! [Cities] {
                                self.objectid = selector.objectId
                            }
                            query2.whereClause = "city_id.objectId = '\(self.objectid)'"
                            
                            dataStore2.find(query2,
                                response: { (result: BackendlessCollection!) -> Void in
                                    let results = result.getCurrentPage()
                                    for selector in results as! [Districts] {
                                        self.towns.append(selector.district)
                                    }
                                },
                                error: { (fault: Fault!) -> Void in
                                    print("Server reported an error: \(fault)")
                            })
                 spiningActivity.hide(true)
            }
            ,
                        error: { (fault: Fault!) -> Void in
                            print("Server reported an error: \(fault)")
        })
    }


}
