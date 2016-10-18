//
//  BaseViewController.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 08/03/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation

class BaseViewController: UIViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = MainPalette.whiteColor()
        self.navigationController?.navigationBar.barTintColor = MainPalette.primaryColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:navigationController, action:nil)
//        AnswersTracking.trackEventScreen("BaseViewController Will Appear")
    }

}