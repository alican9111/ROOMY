//
//  Validate.swift
//  RoommateApp
//
//  Created by Apple on 25/01/16.
//  Copyright © 2016 mac. All rights reserved.
//

import Foundation

extension String {
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .CaseInsensitive)
            return regex.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    //validate PhoneNumber
    var isPhoneNumber: Bool {
        
        let charcter  = NSCharacterSet(charactersInString: "+0123456789").invertedSet
        var filtered:NSString!
        let inputString:NSArray = self.componentsSeparatedByCharactersInSet(charcter)
        filtered = inputString.componentsJoinedByString("")
        return  self == filtered
        
    }
}


extension UIViewController {
    internal func alertmessages(messages: String,titles: String) -> Void
    {
        
        let myalert = UIAlertController(title: titles, message: messages, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okaction = UIAlertAction(title: "Tamam", style: UIAlertActionStyle.Default, handler:nil)
        
        myalert.addAction(okaction);
        
        self.presentViewController(myalert, animated: true, completion: nil)
        
    }
}



extension UIViewController {
    internal func confirmmessages(messages: String,titles: String,delegate: UITableViewController) -> Void
    {
        
            // create the alert
            let alert = UIAlertView()
            alert.message = messages
            alert.title = titles
            alert.delegate = delegate
            alert.addButtonWithTitle("İptal")
            alert.addButtonWithTitle("Devam")
            alert.cancelButtonIndex = 0
        
            alert.show()
        
    }
}

extension UIViewController {
    internal func confirmmessagesforwiew(messages: String,titles: String,delegate: UIViewController) -> Void
    {
        
        // create the alert
        let alert = UIAlertView()
        alert.message = messages
        alert.title = titles
        alert.delegate = delegate
        alert.addButtonWithTitle("İptal")
        alert.addButtonWithTitle("Devam")
        alert.cancelButtonIndex = 0
        
        alert.show()
        
    }
}

extension UIImage {
    func resize(scale:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width*scale, height: size.height*scale)))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    func resizeToWidth(width:CGFloat,height:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: width, height: height )))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

extension UIViewController {
    func colorMe() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.png")!)
    }
}
