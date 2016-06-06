//
//  NewHouseVC.swift
//  RoommateApp
//
//  Created by Alican Özsırma on 30/12/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI

class NewHouseVC: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,
    UIPickerViewDelegate{
    
    var objectid = String()
    var imagePicked = 0
    var cities = [String]()
    var towns = [String]()
    var housesize = ["","1+1","2+1","3+1","4+1"]
    var v_latitude : String = ""
    var v_longitude : String = ""
    
    var backendless = Backendless.sharedInstance()
    
     let myPickerController = UIImagePickerController()
    
    var v_numberofperson : String = "1"
    var v_whoissearched : String = "Bay"
    var v_job : String = "Öğrenci"
    var v_aboutowner : String = "Ev Arkadaşı Arıyorum"
    var citiespickerview = UIPickerView()
    var townpickerview = UIPickerView()
    var housesizepickerview = UIPickerView()
    
    @IBOutlet weak var sizeofhouse: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var adress: UITextField!
    @IBOutlet weak var outlet_numberofperson: UISegmentedControl!

    @IBOutlet weak var textnumberofperson: UILabel!
    @IBOutlet weak var towntext: UITextField!
    @IBOutlet weak var citytext: UITextField!
    @IBOutlet weak var mainphoto: UIImageView!
    @IBOutlet weak var photo1: UIImageView!
    @IBOutlet weak var photo2: UIImageView!
    @IBOutlet weak var photo3: UIImageView!
    

    @IBOutlet weak var explanation: UITextField!
    
    
    //-----Keyboard Control-------------
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    //------------------------------------

    
    override func viewDidLoad() {
        super.viewDidLoad()

        myPickerController.delegate = self
        citiespickerview.delegate = self
        housesizepickerview.delegate = self
        townpickerview.delegate = self
        
        
        citytext.inputView = citiespickerview
        towntext.inputView = townpickerview
        sizeofhouse.inputView = housesizepickerview
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.tintColor = UIColor.blackColor()
        
        let toolbarbutton = UIBarButtonItem(title: "Bitti", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(NewHouseVC.donePicker))
        
        toolbar.setItems([toolbarbutton], animated: false)
        
        toolbar.userInteractionEnabled = true
        
        citytext.inputAccessoryView = toolbar
        sizeofhouse.inputAccessoryView = toolbar
        towntext.inputAccessoryView = toolbar
        
        getCitiesAsync()
        
        
    }
    
func donePicker() {
    
    sizeofhouse.resignFirstResponder()
    citytext.resignFirstResponder()
    towntext.resignFirstResponder()
}
    
    @IBAction func valuechanged(sender: AnyObject) {
        towns.removeAll()
        getCitiesDistrictsAsync()
    }
 
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //-----------Get data from segments----
    @IBAction func action_aboutowner(sender: AnyObject) {
        switch (sender.selectedSegmentIndex)
        {
        case 0: v_aboutowner = "Ev Arkadaşı Arıyorum"
            outlet_numberofperson.hidden = false;
            textnumberofperson.hidden = false;
            
        case 1:
            
            v_aboutowner = "Ev Sahibiyim"
            outlet_numberofperson.hidden = true;
            textnumberofperson.hidden = true;
            
        default : "Ev Arkadaşı Arıyorum"
        }
    }
    @IBAction func action_numberofperson(sender: AnyObject) {
        switch (sender.selectedSegmentIndex){
        case 0: v_numberofperson = "1"
        case 1: v_numberofperson = "2"
        case 2: v_numberofperson = "3+"
        default: "1"
        }
    }
    @IBAction func action_whoissearched(sender: AnyObject) {
        switch(sender.selectedSegmentIndex)
        {
        case 0: v_whoissearched = "Bay"
        case 1: v_whoissearched = "Bayan"
        default : "Bay"
        }
    }
    @IBAction func action_job(sender: AnyObject) {
        switch(sender.selectedSegmentIndex)
        {
        case 0: v_job = "Öğrenci"
        case 1: v_job = "Diğer"
        default : "Öğrenci"
        }
    }
    
    //----------------------------
    @IBAction func selectmainphoto(sender: AnyObject) {
        
        imagePicked = 1
        myPickerController.allowsEditing = false
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        self.presentViewController(myPickerController, animated: true, completion: nil)
       
            }
    
    @IBAction func selectsecondphoto(sender: AnyObject) {
        
        imagePicked = 2
        myPickerController.allowsEditing = false
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    @IBAction func selectthirdphoto(sender: AnyObject) {
        imagePicked = 3
        myPickerController.allowsEditing = false
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    @IBAction func selectfourthphoto(sender: AnyObject) {
        imagePicked = 4
        myPickerController.allowsEditing = false
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if imagePicked == 1 {
            mainphoto.image = info[UIImagePickerControllerOriginalImage] as? UIImage            }
            else if imagePicked == 2
            {
                photo1.image = info[UIImagePickerControllerOriginalImage] as? UIImage
                }
                else if imagePicked == 3
                {
                    photo2.image = info[UIImagePickerControllerOriginalImage] as? UIImage
                    }
                    else if imagePicked == 4
                    {
                        photo3.image = info[UIImagePickerControllerOriginalImage] as? UIImage                        }
     
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //--------Back BUtton-----------
    @IBAction func backbutton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //------------------------------
    
    //----------Picker-View----------
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if (pickerView==citiespickerview)
        {
            return cities.count
        }
        else if (pickerView==housesizepickerview)
        {
            return housesize.count
        }
        else if (pickerView==townpickerview)
        {
            return towns.count
        }
        return 0;
        
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if (pickerView==citiespickerview)
        {
            return cities[row]
        }
        else if (pickerView==housesizepickerview)
        {
            return housesize[row]
        }
        else if (pickerView==townpickerview)
        {
               return towns[row]
            
        }
        return ""
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if (pickerView==citiespickerview)
        {
            citytext.text = cities[row]
        }
        else if (pickerView==housesizepickerview)
        {
            sizeofhouse.text = housesize[row]
        }
        else if (pickerView==townpickerview)
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
        if (segue.identifier == "ContinueSegue") {
            
            let vc: UINavigationController = segue.destinationViewController as! UINavigationController
            
            let svc = vc.topViewController as! NewHouseTVC
            
            if (sizeofhouse.text?.isBlank==true || adress.text?.isBlank==true || citytext.text?.isBlank==true || towntext.text?.isBlank == true || price.text?.isBlank==true)
            {
                    alertmessages("Tüm Alanları Doldurunuz", titles: "Eksik Bilgi")
            }
            else if (mainphoto.image==nil)
            {
                    alertmessages("Eviniz İçin Fotograf Yükleyin(En az 1)", titles: "Eksik Bilgi")            }
            else
            {
            
                svc.mainphoto = mainphoto.image!
                if photo1.image != nil{ svc.photo1 = photo1.image! }
                if photo2.image != nil{ svc.photo2 = photo2.image! }
                if photo3.image !=  nil { svc.photo3 = photo3.image! }
                svc.sizeofhouse = sizeofhouse.text!
                svc.adress = adress.text!
                svc.town = towntext.text!
                svc.city = citytext.text!
                svc.whoissearched = v_whoissearched
                if (outlet_numberofperson.hidden != true)
                {
                    svc.numberofperson = v_numberofperson
                }
                else
                {
                    svc.numberofperson = "0"
                }
                svc.aboutowner = v_aboutowner
                svc.job = v_job
                svc.explanation = explanation.text!
                svc.price = Double(price.text!)!
                svc.latitude = v_latitude
                svc.longitude = v_longitude
            }
        }
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

    //------------------------------
    
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
                                    spiningActivity.hide(true)
                                },
                                error: { (fault: Fault!) -> Void in
                                    print("Server reported an error: \(fault)")
                            })
    
            },
                        error: { (fault: Fault!) -> Void in
                            print("Server reported an error: \(fault)")
        })
    }
    
    @IBAction func find_geolocation(sender: AnyObject) {
        if (adress.text?.isBlank==true)
        {
            alertmessages("Lütfen Evin Açık Adresini Giriniz", titles: "Hata")
        }
        else
        {
            forwardGeocoding(adress.text!+" "+towntext.text!+","+citytext.text!)
        }
        
    }
    
    func forwardGeocoding(address: String) {
        CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                if ((coordinate?.latitude)! == "" && (coordinate?.longitude)! == "")
                {
                    self.alertmessages("Aranılan Adres Bulunamadı!", titles: "Bilgi")
                }
                else
                {
                    self.alertmessages("Lat :'\(coordinate!.latitude)' \n Long: '\(coordinate!.longitude)'", titles: "Adres Bulundu")
                    self.v_latitude = (coordinate?.latitude.description)!
                    self.v_longitude = (coordinate?.longitude.description)!
                    print (self.v_latitude,self.v_longitude)
                }
                
            }
        })
    }
    
}
