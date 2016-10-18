//
//  LoadingController.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 25/07/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import WatchKit
import Foundation
import NKWatchActivityIndicator

class LoadingController: WKInterfaceController {

    static let DISMISS_NOTIF = "hide_loading_view_notification"
    
    @IBOutlet var indicatorImage: WKInterfaceImage!
    var animation : NKWActivityIndicatorAnimation!
    
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        self.animation = NKWActivityIndicatorAnimation(type: NKWActivityIndicatorAnimationType.BallScale, controller: self, images: [self.indicatorImage])
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        animation.startAnimating()
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(hideController),
            name: LoadingController.DISMISS_NOTIF,
            object: nil)
        self.setTitle("")
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        animation.stopAnimating()
    }
    
    func hideController(notification: NSNotification){
        NSNotificationCenter.defaultCenter().removeObserver(self)
        dismissController()
    }
    
}
