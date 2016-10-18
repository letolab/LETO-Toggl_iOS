//
//  WatchCommunication.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 25/07/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchCommunication : NSObject, WCSessionDelegate{
    
    static var lastTrackedEntry : TimeEntry?
    
    internal var session: WCSession? {
        didSet {
            if let session = session {
                session.delegate = self
                session.activateSession()
            }
        }
    }
    
    //MARK WATCH CONNECTIVITY
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        switch message["request"]! as! String {
        case WatchConnectivityUtil.REQUEST_USER_INFO:
            self.getUserInfo(replyHandler)
            break
        case WatchConnectivityUtil.REQUEST_STOP_TASK:
            self.stopTask(replyHandler)
            break
        case WatchConnectivityUtil.REQUEST_START_TASK:
            self.startTask(replyHandler)
            break
        case WatchConnectivityUtil.REQUEST_LOGIN_STATUS:
            self.checkLoginStatus(replyHandler)
            break
        case WatchConnectivityUtil.REQUEST_PROJECTS:
            self.getProjects(replyHandler)
            break
        case WatchConnectivityUtil.REQUEST_START_NEW:
            self.startNewTask(message[WatchConnectivityUtil.NEW_TASK_DESCRIPTION] as! String,pid: message[WatchConnectivityUtil.NEW_TASK_PID] as! Int, billabe: message[WatchConnectivityUtil.NEW_TASK_BILLABLE] as! Bool, replyHandler: replyHandler)
            break
        default:
            break
        }
    }
    
    func getUserInfo(replyHandler: ([String : AnyObject]) -> Void){
        LetoTogglRestClient.sharedInstance.getUserInfo(
            {(result:TogglUser) in
                var response : [String : AnyObject] = ["":""]
                let timeEntries = AppUtils.createCompleteEntriesModel(result.data.timeEntries, projects: result.data.projects, clients: result.data.clients)
                
                
                if  timeEntries.count > 0 {
                    
                    let lastEntry = timeEntries.last!

                    
                    if lastEntry.stop != nil {
                        let lastTask = lastEntry
                        response = [
                            WatchConnectivityUtil.LAST_TASK_NAME : lastTask.descriptionField,
                            WatchConnectivityUtil.LAST_PROJ_NAME : lastTask.projectObj!.name!,
                            WatchConnectivityUtil.LAST_TASK_DURATION : lastTask.duration,
                            WatchConnectivityUtil.LAST_PROJ_COLOR :Int((lastTask.projectObj?.color)!)!]
                        
                        WatchCommunication.lastTrackedEntry=lastTask
                    }else{
                        let currentTask = timeEntries.last
                        let lastTask = timeEntries[timeEntries.count - 2]
                        
                        response = [WatchConnectivityUtil.CURRENT_TASK_NAME : currentTask!.descriptionField,
                            WatchConnectivityUtil.CURRENT_PROJ_NAME : currentTask!.projectObj!.name!,
                            WatchConnectivityUtil.CURRENT_TASK_DURATION : currentTask!.duration,
                            WatchConnectivityUtil.CURRENT_PROJ_COLOR : Int((currentTask!.projectObj?.color)!)!,
                            WatchConnectivityUtil.LAST_TASK_NAME : lastTask.descriptionField,
                            WatchConnectivityUtil.LAST_PROJ_NAME : lastTask.projectObj!.name!,
                            WatchConnectivityUtil.LAST_TASK_DURATION : lastTask.duration,
                            WatchConnectivityUtil.LAST_PROJ_COLOR : Int((lastTask.projectObj?.color)!)!]
                        WatchCommunication.lastTrackedEntry=lastTask
                    }
                }

                replyHandler(response)
            },
            failure: {(error:String) in
                
        })
    }
    
    func stopTask(replyHandler: ([String : AnyObject]) -> Void){
        AppPreferences.setSnooze(false)
        LetoTogglRestClient.sharedInstance.stopCurrentTimeEntry({ () -> Void in
            replyHandler(["result":true])
        }) { (error) -> Void in
            replyHandler(["result":false])
        }
    }
    
    func startTask(replyHandler: ([String : AnyObject]) -> Void){
        AppPreferences.setSnooze(false)
        let startTimeEntry = WatchCommunication.lastTrackedEntry!
        startTimeEntry.stop=nil
        startTimeEntry.id=nil
        startTimeEntry.guid=nil
        startTimeEntry.createdWith="Leto Toggl watch OS"
        startTimeEntry.start = AppUtils.ISOStringFromDate(NSDate())
        startTimeEntry.duration = Int(-NSDate().timeIntervalSince1970)
        let startEntryModel = StartTimeEntryModel(fromEntry: startTimeEntry)
        LetoTogglRestClient.sharedInstance.startEntry(startEntryModel, success: { (response) -> Void in
            replyHandler(["result":true])
            }, failure: { (error) -> Void in
                replyHandler(["result":false])
        })
    }
    
    func checkLoginStatus(replyHandler: ([String : AnyObject]) -> Void){
        if let apiToken = AppPreferences.getApiToken(){
            if apiToken as! String != "" {
                replyHandler(["result":true])
            }else{
                replyHandler(["result":false])
            }
        }else{
            replyHandler(["result":false])
        }
    }
    
    func getProjects(replyHandler: ([String : AnyObject]) -> Void){
        LetoTogglRestClient.sharedInstance.getProjectsList(workspaceID: AppPreferences.getWorksapceID() as! Int, success: { (projects) in
            var projectsDict : [[String:AnyObject]] = []
            let sortedProjects = projects.sort({ $0.name < $1.name })
            for proj in sortedProjects {
                projectsDict.append(proj.toDictionary() as! [String : AnyObject])
            }
            replyHandler([WatchConnectivityUtil.PROJECTS_LIST:projectsDict])
            }, failure: { (error) -> Void in
                replyHandler(["result":false])
        })

    }
    
    func startNewTask(name:String, pid:Int, billabe:Bool, replyHandler: ([String : AnyObject]) -> Void){
        let startTimeEntry = TimeEntry()
        startTimeEntry.descriptionField = name
        startTimeEntry.pid = pid
        startTimeEntry.billable = billabe
        startTimeEntry.stop=nil
        startTimeEntry.id=nil
        startTimeEntry.guid=nil
        startTimeEntry.createdWith="Leto Toggl watch OS"
        startTimeEntry.start = AppUtils.ISOStringFromDate(NSDate())
        startTimeEntry.duration = Int(-NSDate().timeIntervalSince1970)
        let startEntryModel = StartTimeEntryModel(fromEntry: startTimeEntry)
        LetoTogglRestClient.sharedInstance.startEntry(startEntryModel, success: { (response) -> Void in
            replyHandler(["result":true])

            }, failure: { (error) -> Void in
                replyHandler(["result":false])
        })
    }
    
}