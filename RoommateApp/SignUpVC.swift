//
//  SignUpVC.swift
//  RoommateApp
//
//  Created by Alican Özsırma on 18/12/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit


class SignUpVC: UIViewController, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var backendless = Backendless.sharedInstance()
    var cities = [String]()
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var profilephoto: UIImageView!
    @IBOutlet weak var segmentjob: UISegmentedControl!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordagain: UITextField!
    @IBOutlet weak var firstname: UITextField!
    @IBOutlet weak var lastname: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var datetext: UITextField!
    @IBOutlet weak var citytext: UITextField!
    @IBOutlet weak var segmentgender: UISegmentedControl!
    
    
    var date = NSDate()
    var datepicker : UIDatePicker = UIDatePicker()
    var citiespickerview = UIPickerView()
    var returnjob:String = "Öğrenci"
    var returngender:String = "Bay"
    var citycontrol = false
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCitiesAsyc()

        citiespickerview.delegate = self
        datepicker.datePickerMode = UIDatePickerMode.Date
         datepicker.maximumDate = NSCalendar.currentCalendar().dateByAddingUnit(.Year, value: -16, toDate: NSDate(), options: [])
        datepicker.minimumDate = NSCalendar.currentCalendar().dateByAddingUnit(.Year, value: -40, toDate: NSDate(), options: [])
        date = datepicker.date
        datepicker.addTarget(self, action: #selector(SignUpVC.datepickerValueChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        datetext.inputView = datepicker
        citytext.inputView = citiespickerview
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barStyle = UIBarStyle.Default
        toolbar.tintColor = UIColor.blackColor()
        let toolbarbutton = UIBarButtonItem(title: "Bitti", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SignUpVC.donePicker))
        
        toolbar.setItems([toolbarbutton], animated: false)
        toolbar.userInteractionEnabled = true
        
        datetext.inputAccessoryView = toolbar
        citytext.inputAccessoryView = toolbar
        
    }
    
    func donePicker() {
        datetext.resignFirstResponder()
        citytext.resignFirstResponder()
    }
    
    func datepickerValueChanged(sender: UIDatePicker){
        
        let dateformatter = NSDateFormatter()
        dateformatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateformatter.timeStyle = NSDateFormatterStyle.NoStyle
        datetext.text = dateformatter.stringFromDate(sender.date)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //------------RegisterMe----------
    @IBAction func savemebutton(sender: AnyObject) {
        
       if (email.text?.isBlank==true || password.text?.isBlank==true || passwordagain.text?.isBlank==true || firstname.text?.isBlank==true || lastname.text?.isBlank==true || datetext.text?.isBlank==true || citytext.text?.isBlank==true)
       {
           alertmessages("Boş Alanları Doldurunuz", titles: "Eksik Bilgi")
        }
        else if (email.text?.isEmail==false)
       {
           alertmessages("E-Mail Hatalı", titles: "Hatalı Bilgi")
        }
        else if (phone.text?.isPhoneNumber==false)
       {
           alertmessages("Telefon Hatalı", titles: "Hatalı Bilgi")
        }
        else if (password.text != passwordagain.text)
       {
          alertmessages("Şifreniz Uyuşmuyor", titles: "Hatalı Bilgi")
        }
       else if (citycontrol==false)
       {
          alertmessages("Yaşadığınız Şehri Seçiniz", titles: "Hatalı Bilgi")
       }
       else{
        
        //------Show UIActivity-------
        let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spiningActivity.labelText = "Gönderiliyor"
        spiningActivity.detailsLabelText = "Lütfen Bekleyin"
        //-----------------------------------
        
        let user = BackendlessUser()
        user.email = self.email.text
        user.password = self.password.text
        user.setProperty("first_name", object:self.firstname.text!)
        user.setProperty("last_name", object:self.lastname.text!)
        user.setProperty("birth_date", object:self.date)
        user.setProperty("phone", object:self.phone.text!)
        user.setProperty("city", object:self.citytext.text!)
        user.setProperty("job", object:self.returnjob)
        user.setProperty("gender", object:self.returngender)
        
       registerUserAsync(user,spiningActivity: spiningActivity)
        
        }
        
    }
    
    //---------ProfilPhotoButton-------
    @IBAction func selectprofilephoto(sender: AnyObject) {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
                self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
                profilephoto.image = info[UIImagePickerControllerOriginalImage] as? UIImage
                self.dismissViewControllerAnimated(true, completion: nil)
    }
    //-------------------------------

    
    //---------BarButton-Back-------
    @IBAction func backbutton(sender: AnyObject) {
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    //------------------------------
    
    
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
        citytext.text = cities[row]
        citycontrol = true
    }
    //-------------------------------
    
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

    
    
    //--------Segment JOB---------------
    @IBAction func selectjob(sender: AnyObject) {
        switch sender.selectedSegmentIndex
        {
        case 0:returnjob="Öğrenci"
        case 1:returnjob="Diğer"
        default:returnjob="Öğrenci"
        }
    }
    //--------------------------------
    
    //------Segment GENDER----------
    
    @IBAction func selectgender(sender: AnyObject) {
        switch sender.selectedSegmentIndex
        {
        case 0:returngender="Bay"
        case 1:returngender="Bayan"
        default:returngender="Bay"
        }
    }
    //-------------------------------------------
    
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
    
    func registerUserAsync(user:BackendlessUser,spiningActivity:MBProgressHUD)
    {
        backendless.userService.registering(user,
                response: { ( registeredUser : BackendlessUser!) -> () in
                                                
                            if (self.profilephoto.image != nil)
                                    {
                                        self.backendless.fileService.upload("/users/"+String(user.getProperty("objectId"))+".jpeg", content: UIImageJPEGRepresentation(self.profilephoto.image!.resizeToWidth(640, height: 480), 0))
                                    }
                                    else if (self.profilephoto.image == nil)
                                    {
                                                    self.backendless.fileService.upload("/users/"+String(user.getProperty("objectId"))+".jpeg", content: UIImageJPEGRepresentation(UIImage(named: "avatar")!, 0))
                                    }
                                                
                                    spiningActivity.hide(true)
                                                
                                    self.alertmessages("Kayıt İşlemi Tamamlandı", titles: "Tebrikler")
                                                
                                    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                                
                                    let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ViewControllerNC") as UIViewController
                                                appDelegate.window?.rootViewController = initialViewController
                                                appDelegate.window?.makeKeyAndVisible()
                                                
            },
                                error: { ( fault : Fault!) -> () in
                                        spiningActivity.hide(true)
                                                
                                        if(fault.faultCode == "2002")
                                            {
                                                self.alertmessages("Uygulamayı Güncelleştiriniz", titles: "Hata")
                                            }
                                            else if (fault.faultCode == "3033")
                                            {
                                                self.alertmessages("Aynı Mail ile Kullanıcı Mevcut", titles: "Hata")
                                                }
                                                else
                                                {
                                                    self.alertmessages("Kayıt İşlemi Tamamlanmadı", titles: "Hata")
                                                }})
    }
    
}
