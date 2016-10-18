//
//  LastTaskController.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 25/07/16.
//  Copyright © 2016 Leto. All rights reserved.
//
import WatchKit
import Foundation
import WatchConnectivity

class LastTaskController: WKInterfaceController, WCSessionDelegate{
    
    @IBOutlet var lastTaskName: WKInterfaceLabel!
    @IBOutlet var lastProjName: WKInterfaceLabel!
    @IBOutlet var lastTaskDuration: WKInterfaceLabel!
    @IBOutlet var projNameBg: WKInterfaceGroup!

    var timer = NSTimer()
    var currentDurationValue : Int = -1
    
    var userInfo:AnyObject?
    var isCrurrentVisible = true
    
    var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        // Configure interface objects here.
        if context != nil{
            userInfo = context as! [String:AnyObject]
            if let responseData = userInfo![WatchConnectivityUtil.LAST_TASK_NAME] as? String{
                    self.lastTaskName.setText(responseData)
                    self.currentDurationValue = self.userInfo![WatchConnectivityUtil.LAST_TASK_DURATION] as! Int
                    self.lastTaskDuration.setText(WatchUtils.getDurationString(self.currentDurationValue))
            }
            if let responseData = userInfo![WatchConnectivityUtil.LAST_PROJ_NAME] as? String{
                self.lastProjName.setText(responseData)
                self.projNameBg.setBackgroundColor(WatchUtils.getColorFromIndex(userInfo![WatchConnectivityUtil.LAST_PROJ_COLOR] as! Int))
            }else{
                self.projNameBg.setBackgroundColor(UIColor.clearColor())
                self.lastProjName.setHidden(true)
            }
            
            if (userInfo![WatchConnectivityUtil.CURRENT_TASK_NAME] as? String) != nil {
                isCrurrentVisible=true
            }else{
                isCrurrentVisible=false
            }
        }
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if userInfo == nil && !isCrurrentVisible{
            checkLoginStatus()
        }else{
            userInfo = nil
        }
    }
    
    private func getUserInfo () {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session!.sendMessage(["request": WatchConnectivityUtil.REQUEST_USER_INFO], replyHandler: { (response) -> Void in
                if (response[WatchConnectivityUtil.CURRENT_TASK_NAME] as? String) != nil{
                    WKInterfaceController.reloadRootControllersWithNames(["current", "last"], contexts: [response,response])
                }else{
                    WKInterfaceController.reloadRootControllersWithNames(["last"], contexts: [response])
                }
                }, errorHandler: { (error) -> Void in
                    print(error)
            })
        }
    }
    
    private func checkLoginStatus() {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session!.sendMessage(["request": WatchConnectivityUtil.REQUEST_LOGIN_STATUS], replyHandler: { (response) -> Void in
                if (response["result"] as? Bool) == true{
                    self.getUserInfo()
                }else{
                    WKInterfaceController.reloadRootControllersWithNames(["loginRequest"], contexts: nil)
                }
                }, errorHandler: { (error) -> Void in
                    print(error)
            })
        }
    }
    
    @IBAction func startPressed() {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session!.sendMessage(["request": WatchConnectivityUtil.REQUEST_START_TASK], replyHandler: { (response) -> Void in
                if (response["result"] as? Bool) == true{
                    WKInterfaceController.reloadRootControllersWithNames(["current", "last"], contexts: nil)
                }
                }, errorHandler: { (error) -> Void in
                    print(error)
            })
        }
    }
    
}
