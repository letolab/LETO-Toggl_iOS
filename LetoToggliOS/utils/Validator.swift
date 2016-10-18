//
//  Validator.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 08/03/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation

class Validator {
    
    static func areStringNotEmpty (strings:[String], vc:UIViewController, showAlert:Bool) ->Bool{
        for string:String in strings {
            if string.isEmpty{
                if showAlert{
                    let alertController = UIAlertController(title: NSLocalizedString("localized_error",comment:""), message: NSLocalizedString("localized_empty_fields",comment:""), preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                        
                    }
                    alertController.addAction(OKAction)
                    vc.presentViewController(alertController, animated: true, completion:nil)
                }
                return false
            }
        }
        return true
    }
    
    static func isEmailValid (email:String, vc:UIViewController, showAlert:Bool) ->Bool{
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result:Bool = emailTest.evaluateWithObject(email)
        
        if !result{
            if showAlert{
                let alertController = UIAlertController(title: NSLocalizedString("localized_error",comment:""), message: NSLocalizedString("localized_email_not_valid",comment:""), preferredStyle: .Alert)
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                    
                }
                alertController.addAction(OKAction)
                vc.presentViewController(alertController, animated: true, completion:nil)
            }
            return false
        }
        
        return true
    }
}