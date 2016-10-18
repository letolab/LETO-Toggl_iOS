//
//  GlanceController.swift
//  LetoTogglWatchiOS Extension
//
//  Created by Lorenzo Greco on 22/07/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class GlanceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var currenTaskName: WKInterfaceLabel!
    @IBOutlet var currentProjName: WKInterfaceLabel!
    @IBOutlet var currentTaskDuration: WKInterfaceLabel!
    @IBOutlet var projNameBg: WKInterfaceGroup!
    
    @IBOutlet var loadingGroup: WKInterfaceGroup!
    @IBOutlet var noTaskGroup: WKInterfaceGroup!
    @IBOutlet var currentTaskGroup: WKInterfaceGroup!
    @IBOutlet var loginGroup: WKInterfaceGroup!
    
    var timer = NSTimer()
    var currentDurationValue : Int = 1
    
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
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        checkLoginStatus()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func updateCounter() {
        let delay = 1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            if (self.currentDurationValue != 1){
                self.currentTaskDuration.setText(WatchUtils.getDurationString(self.currentDurationValue))
            }
            self.updateCounter()
        }
    }
    
    private func checkLoginStatus() {
        loadingGroup.setHidden(false)
        currentTaskGroup.setHidden(true)
        noTaskGroup.setHidden(true)
        self.loginGroup.setHidden(true)
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session!.sendMessage(["request": WatchConnectivityUtil.REQUEST_LOGIN_STATUS], replyHandler: { (response) -> Void in
                if (response["result"] as? Bool) == true{
                    self.getUserInfo()
                }else{
                    self.loginGroup.setHidden(false)
                    self.loadingGroup.setHidden(true)
                }
                }, errorHandler: { (error) -> Void in
                    print(error)
            })
        }
    }
    
    private func getUserInfo () {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session!.sendMessage(["request": WatchConnectivityUtil.REQUEST_USER_INFO], replyHandler: { (response) -> Void in
                self.loadingGroup.setHidden(true)
                if (response[WatchConnectivityUtil.CURRENT_TASK_NAME] as? String) != nil{
                    self.currentTaskGroup.setHidden(false)
                    self.noTaskGroup.setHidden(true)
                    if let responseData = response[WatchConnectivityUtil.CURRENT_TASK_NAME] as? String{
                        self.currenTaskName.setText(responseData)
                        self.currentDurationValue = response[WatchConnectivityUtil.CURRENT_TASK_DURATION] as! Int
                        self.currentTaskDuration.setText(WatchUtils.getDurationString(self.currentDurationValue))
                        self.updateCounter()
                    }
                    if let responseData = response[WatchConnectivityUtil.CURRENT_PROJ_NAME] as? String{
                        self.currentProjName.setHidden(false)
                        self.currentProjName.setText(responseData)
                        self.projNameBg.setBackgroundColor(WatchUtils.getColorFromIndex(response[WatchConnectivityUtil.CURRENT_PROJ_COLOR] as! Int))
                    }else{
                        self.currentProjName.setText("")
                        self.projNameBg.setBackgroundColor(UIColor.clearColor())
                        self.currentProjName.setHidden(true)
                    }
                }else{
                    self.currentTaskGroup.setHidden(true)
                    self.noTaskGroup.setHidden(false)
                    self.currentDurationValue=1
                    self.currentTaskDuration.setText("")
                }
                }, errorHandler: { (error) -> Void in
                    print(error)
            })
        }
    }

}
