//
//  ViewController.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 03/03/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import UIKit
import TextFieldEffects
import Crashlytics

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!

    @IBOutlet weak var signInBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBarHidden = true
        AnswersTracking.trackEventScreen("LoginViewController Will Appear")
    }
    
    func initUI(){
        emailTF.placeholder=NSLocalizedString("localized_email",comment:"")
        passwordTF.placeholder=NSLocalizedString("localized_password",comment:"")
        signInBtn.setTitle(NSLocalizedString("localized_sign_in",comment:""), forState: .Normal)
        emailTF.autocorrectionType = .No
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func signInPressed() {
        let email = emailTF.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if Validator.areStringNotEmpty([email, passwordTF.text!], vc: self, showAlert: true) && Validator.isEmailValid(email, vc: self, showAlert: true){
            LoadingView.sharedInstance.show(self.view)
            self.view.endEditing(true)
            LetoTogglRestClient.sharedInstance.loginUser(emailTF.text! , password:passwordTF.text!,
                success: {(result:TogglUser) in
//                    self.loadingView.hide()
                    AppPreferences.setApiToken(result.data.apiToken)
                    self.performSegueWithIdentifier("goToMainPage", sender: self)
                },
                failure: {(error) in
                    LoadingView.sharedInstance.hide()
                    let alertController = UIAlertController(title: NSLocalizedString("localized_error",comment:""), message: NSLocalizedString("localized_error_login",comment:""), preferredStyle: .Alert)
                    let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                    }
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion:nil)
                    print("ERROR: \(error)")
            })
            
        }
    }
    
    @IBAction func showPressed(sender: UIButton) {
        if sender.titleLabel?.text == "Show password"{
            sender.setTitle("Hide password", forState: .Normal)
        }else{
            sender.setTitle("Show password", forState: .Normal)
        }
        passwordTF.secureTextEntry = !passwordTF.secureTextEntry;
    }

    
    
       
}

