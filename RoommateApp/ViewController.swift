//
//  ViewController.swift
//  RoommateApp
//
//  Created by Alican Özsırma on 18/12/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    var backendless = Backendless.sharedInstance()

    @IBOutlet weak var email_txt: UITextField!
    @IBOutlet weak var password_txt: UITextField!
    
    @IBAction func loginclick(sender: AnyObject) {
        
        let v_email = email_txt.text
        let v_pass = password_txt.text
        
        if (v_email?.isBlank==true || v_pass?.isBlank==true)
        {
            
            alertmessages("E-mail yada parola girilmedi", titles: "Eksik Bilgi")
            
        }
        else if (v_email?.isEmail==false)
        {
            alertmessages("Geçerli E-mail giriniz", titles: "Hatalı Bilgi")
        }
        else{
            
            //------Show UIActivity-------
            let spiningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            spiningActivity.labelText = "Gönderiliyor"
            spiningActivity.detailsLabelText = "Lütfen Bekleyin"
            //-----------------------------------
            
            loginUserAsync(v_email!,v_pass: v_pass!,spiningActivity: spiningActivity)
            
                  }}
    
    @IBAction func actionfacebook(sender: AnyObject) {
        let fieldsMapping = [
           
            "first_name": "first_name",
            "last_name" : "last_name",
            "gender": "gender",
            "email": "email"]
        
        backendless.userService.easyLoginWithFacebookFieldsMapping(
            fieldsMapping,
            permissions: ["email"],
            response: {(result : NSNumber!) -> () in
                print ("Result: \(result)")
                
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                
                let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier("GeneralTabBarController") as UIViewController
                appDelegate.window?.rootViewController = initialViewController
                appDelegate.window?.makeKeyAndVisible()
                
            },
            error: { (fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // colorMe()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //-----Keyboard Control---------override ----
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    //------------------------------------
    
    @IBAction func passwordreset(sender: AnyObject) {
        
        var tField: UITextField!
        
        func configurationTextField(textField: UITextField!)
        {
            textField.placeholder = "E-mail Adresiniz"
            tField = textField
        }
        
        func handleCancel(alertView: UIAlertAction!)
        {
            print("Cancelled !!")
        }
        
        let alert = UIAlertController(title: "Şifre Sıfırla", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addTextFieldWithConfigurationHandler(configurationTextField)
        alert.addAction(UIAlertAction(title: "Vazgeç", style: UIAlertActionStyle.Cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title: "Devam", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
        
        
            self.backendless.userService.restorePassword(tField.text,
                                                     response:{ ( result : AnyObject!) -> () in
                                                        print("Check your email address! result = \(result)")
                },
                                                     error: { ( fault : Fault!) -> () in
                                                        print("Server reported an error: \(fault)")
                }
            )
        
        
        }))
        self.presentViewController(alert, animated: true, completion: {
        })
    
    }
    
    func loginUserAsync(v_email:String,v_pass:String,spiningActivity:MBProgressHUD)
    {
        backendless.userService.login(
            v_email, password:v_pass,
            response: { ( registeredUser : BackendlessUser!) -> () in
    
                spiningActivity.hide(true)
                
                /*let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(v_email, forKey: "email")
                defaults.setObject(v_pass, forKey: "password")
                NSUserDefaults.standardUserDefaults().synchronize()*/
    
                let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
                let initialViewController = self.storyboard!.instantiateViewControllerWithIdentifier("GeneralTabBarController") as UIViewController
                appDelegate.window?.rootViewController = initialViewController
                appDelegate.window?.makeKeyAndVisible()
    
    
            },
            error: { ( fault : Fault!) -> () in
                spiningActivity.hide(true)
                if (fault.faultCode == "2002")
                {
                    self.alertmessages("Uygulamayı Güncelleştiriniz", titles: "Hata")
                }
                else if (fault.faultCode == "3000")
                {
                    self.alertmessages("Hesabınız Devre Dışı Bırakılmıştır", titles: "Hata")
                }
                else if (fault.faultCode == "3002")
                {
                    self.alertmessages("Hesabınızla Oturum Açılmış", titles: "Hata")
                }
                else if (fault.faultCode == "3003")
                {
                    self.alertmessages("Mail yada Şifre Hatalı", titles: "Hata")
                }
                else
                {
                    self.alertmessages("Sisteme Giriş Yapılamadı", titles: "Hata")
                }
                print(fault.description)
        })
    }
}
