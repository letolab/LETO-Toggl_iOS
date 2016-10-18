//
//  LoadingController.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 01/08/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import WatchKit
import Foundation
import NKWatchActivityIndicator
import WatchConnectivity

class NewTaskController: WKInterfaceController, WCSessionDelegate{
    
    @IBOutlet var descriptionBtn: WKInterfaceButton!
    @IBOutlet var projectBtn: WKInterfaceButton!
    @IBOutlet var billableSwitch: WKInterfaceSwitch!
    @IBOutlet var startBtn: WKInterfaceButton!
    
    var pid:Int?
    var taskName: String?{
        didSet{
            self.descriptionBtn.setTitle(taskName)
        }
    }
    var isBillable = true
    
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
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if ProjectsListController.selectedProj != nil {
            projectBtn.setTitle(ProjectsListController.selectedProj?.name)
            pid = ProjectsListController.selectedProj?.id
            ProjectsListController.selectedProj = nil
        }
        self.taskName = "Watch task"
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func descriptionAction() {
        self.presentTextInputControllerWithSuggestions(["New Task","Watch task","-"], allowedInputMode: WKTextInputMode.Plain,
                                                       completion:{(results) -> Void in
                                                        let des = results?[0] as? String
                                                        self.taskName = des!;
        })
    }
    
    @IBAction func switchAction(value: Bool) {
        isBillable=value
    }
    
    @IBAction func startAction() {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            startBtn.setEnabled(false)
            session!.sendMessage(["request": WatchConnectivityUtil.REQUEST_START_NEW, WatchConnectivityUtil.NEW_TASK_DESCRIPTION: self.taskName!, WatchConnectivityUtil.NEW_TASK_PID : self.pid!, WatchConnectivityUtil.NEW_TASK_BILLABLE: isBillable], replyHandler: { (response) -> Void in
                self.startBtn.setEnabled(true)
                if (response["result"] as? Bool) == true{
                    self.dismissController()
                }else{
                   
                }
                }, errorHandler: { (error) -> Void in
                    self.startBtn.setEnabled(true)
                    print(error)
            })
        }
    }
    
    
    
}
