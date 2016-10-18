//
//  InterfaceController.swift
//  LetoTogglWatchiOS Extension
//
//  Created by Lorenzo Greco on 22/07/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class CurrentTaskController: WKInterfaceController, WCSessionDelegate{

    @IBOutlet var currenTaskName: WKInterfaceLabel!
    @IBOutlet var currentProjName: WKInterfaceLabel!
    @IBOutlet var currentTaskDuration: WKInterfaceLabel!
    @IBOutlet var projNameBg: WKInterfaceGroup!
    
    var taskName:String = ""
    var projName:String = ""
    var taskDuration:Int = 0
    var projColorIndex:Int = 0
    
    var timer = NSTimer()
    var currentDurationValue : Int = 1
    
    var userInfo:AnyObject?
    
    var isShowingNew = false
    
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
            if let responseData = userInfo![WatchConnectivityUtil.CURRENT_TASK_NAME] as? String{
                taskName=responseData
                self.currenTaskName.setText(taskName)
                self.currentDurationValue = self.userInfo![WatchConnectivityUtil.CURRENT_TASK_DURATION] as! Int
                self.currentTaskDuration.setText(WatchUtils.getDurationString(self.currentDurationValue))
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: #selector(CurrentTaskController.updateCounter), userInfo: nil, repeats: true)
            }
            if let responseData = userInfo![WatchConnectivityUtil.CURRENT_PROJ_NAME] as? String{
                self.currentProjName.setHidden(false)
                projName = responseData
                self.currentProjName.setText(projName)
                projColorIndex = userInfo![WatchConnectivityUtil.CURRENT_PROJ_COLOR] as! Int
                self.projNameBg.setBackgroundColor(WatchUtils.getColorFromIndex(projColorIndex))
            }else{
                projName=""
                self.projNameBg.setBackgroundColor(UIColor.clearColor())
                self.currentProjName.setHidden(true)
            }
        }
        
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if userInfo == nil{
            if currentDurationValue == 1 {
                presentControllerWithName("loading", context: nil)
            }
            checkLoginStatus()
        }else{
            userInfo = nil

        }
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func updateCounter() {
        if (currentDurationValue != 1){
            taskDuration = currentDurationValue
            self.currentTaskDuration.setText(WatchUtils.getDurationString(self.currentDurationValue))
            let nowDouble = NSDate().timeIntervalSince1970
            taskDuration = Int(nowDouble) + currentDurationValue
        }
    }
    
    private func getUserInfo () {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session!.sendMessage(["request": WatchConnectivityUtil.REQUEST_USER_INFO], replyHandler: { (response) -> Void in
                if(!self.isShowingNew){
                    if (response[WatchConnectivityUtil.CURRENT_TASK_NAME] as? String) != nil{
                        WKInterfaceController.reloadRootControllersWithNames(["current", "last"], contexts: [response,response])
                    }else{
                        WKInterfaceController.reloadRootControllersWithNames(["last"], contexts: [response])
                    }
                }else{
                    self.isShowingNew=false
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
                    NSNotificationCenter.defaultCenter().postNotificationName(LoadingController.DISMISS_NOTIF, object: nil)
                    WKInterfaceController.reloadRootControllersWithNames(["loginRequest"], contexts: nil)
                }
                }, errorHandler: { (error) -> Void in
                    print(error)
            })
        }
    }
    
    @IBAction func stopPressed() {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session!.sendMessage(["request": WatchConnectivityUtil.REQUEST_STOP_TASK], replyHandler: { (response) -> Void in
                if (response["result"] as? Bool) == true{
                    let lastTask = [
                        WatchConnectivityUtil.LAST_TASK_NAME : self.taskName,
                        WatchConnectivityUtil.LAST_PROJ_NAME : self.projName,
                        WatchConnectivityUtil.LAST_TASK_DURATION : self.taskDuration,
                        WatchConnectivityUtil.LAST_PROJ_COLOR :self.projColorIndex]
                    WKInterfaceController.reloadRootControllersWithNames(["last"], contexts: [lastTask])
                }
                }, errorHandler: { (error) -> Void in
                    print(error)
            })
        }
    }
    
    //Context menu
    @IBAction func newTaskPressed() {
        isShowingNew = true
        self.presentControllerWithName("new_task", context: nil)
    }
    
    
}
