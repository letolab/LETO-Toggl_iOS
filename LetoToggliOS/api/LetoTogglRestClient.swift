//
//  LetoTogglRestClient.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 03/03/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation
import Alamofire

class LetoTogglRestClient {
   
    let BASE_URL="https://www.toggl.com/api/v8";
    
    var headers = [
        "Content-Type": "application/json"
    ]
    
    class var sharedInstance: LetoTogglRestClient {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: LetoTogglRestClient? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = LetoTogglRestClient()
        }
        return Static.instance!
    }
    
        
    init() {
        if let apiToken = AppPreferences.getApiToken(){
            let credentialData = "\(apiToken):api_token".dataUsingEncoding(NSUTF8StringEncoding)!
            let base64Credentials = credentialData.base64EncodedStringWithOptions([])
            headers["Authorization"]="Basic \(base64Credentials)"
        }
    }
    
    // MARK: ENDPOINTS
    
    func loginUser(username:String, password:String, success: (TogglUser)->Void, failure:(String)->Void) {
        let username = username.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let credentialData = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        headers["Authorization"]="Basic \(base64Credentials)"
        Alamofire.request(.GET, "\(BASE_URL)/me", headers: headers, parameters: nil)
            .responseJSON { response in
//                debugPrint(response.request)
//                debugPrint(response)
                switch response.result {
                case .Success:
                    let togglUser : TogglUser = TogglUser.init(fromDictionary: self.convertDataToDictionary(response.data!)!)
                    print(togglUser.since)
                    success(togglUser)
                    AnswersTracking.trackEventLoginSuccess()
                case .Failure(let error):
                    print(response.data)
                    print(error)
                    failure(error.debugDescription)
                }
        }
    }
    
    func getUserInfo(success:(TogglUser)->Void, failure:(String)->Void) {
        Alamofire.request(.GET, "\(BASE_URL)/me?with_related_data=true", headers: headers, parameters: nil)
            .responseJSON { response in
//                debugPrint(response.request)
//                debugPrint(response)
                switch response.result {
                case .Success:
                    let togglUser : TogglUser = TogglUser.init(fromDictionary: self.convertDataToDictionary(response.data!)!)
                    print(togglUser.since)
                    success(togglUser)
                case .Failure(let error):
                    print(error)
                    failure(error.debugDescription)
                }
        }
    }
    
    func getTimeEntries(startDate:String, endDate:String, success:([TimeEntry])->Void, failure:(String)->Void) {
        Alamofire.request(.GET, "\(BASE_URL)/time_entries", headers: headers, parameters: ["start_date":startDate, "end_date":endDate])
            .responseJSON { response in
//                debugPrint(response.request)
//                debugPrint(response)
                switch response.result {
                case .Success:
                    var json: Array<[String:AnyObject]>!
                    do {
                        json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions()) as? Array
                    } catch {
                        print(error)
                    }
                    var timeEntries : [TimeEntry] = Array()
                    for item : [String: AnyObject] in json{
                        let timeEntry = TimeEntry.init(fromDictionary: item)
                        timeEntries.append(timeEntry)
                    }
                    success(timeEntries)
                case .Failure(let error):
                    print(error)
                    failure(error.debugDescription)
                }
        }
    }
    
    func getCurrentEntry(success:(TimeEntry?)->Void, failure:(String)->Void) {
        Alamofire.request(.GET, "\(BASE_URL)/time_entries/current", headers: headers, parameters: nil)
            .responseJSON { response in
//                debugPrint(response.request)
//                debugPrint(response)
                switch response.result {
                case .Success:
                    let timeEntry : TimeEntry?
                    if response.data?.length>20{
                    let timeEntryModel = TimeEntryModel.init(fromDictionary: self.convertDataToDictionary(response.data!)!)
                        timeEntry = timeEntryModel.data!
                    }else {
                        timeEntry=nil
                    }
                    success(timeEntry)
                case .Failure(let error):
                    print(error)
                    failure(error.debugDescription)
                }
        }
    }
    
    func stopEntry(taskId:String, success:(TimeEntry)->Void, failure:(String)->Void) {
        Alamofire.request(.PUT, "\(BASE_URL)/time_entries/\(taskId)/stop", headers: headers, parameters: nil)
            .responseJSON { response in
//                debugPrint(response.request)
//                debugPrint(response)
                switch response.result {
                case .Success:
                    if let datafromResponse = response.data{
                        let timeEntryModel = TimeEntryModel.init(fromDictionary: self.convertDataToDictionary(datafromResponse)!)
                        let timeEntry : TimeEntry = timeEntryModel.data!
                        AnswersTracking.trackEventStopEntrySuccess(timeEntry)
                        success(timeEntry)
                    }else{
                        AnswersTracking.trackEventResponseDataNil(response.data,nameMethod: "stopEntry in LetoTogglRestClient")
                    }
                    
                case .Failure(let error):
                    print(error)
                    failure(error.debugDescription)
                }
        }
    }
    
    func startEntry(task:StartTimeEntryModel, success:(TimeEntry)->Void, failure:(String)->Void) {
        Alamofire.request(.POST, "\(BASE_URL)/time_entries", headers: headers, parameters: task.toDictionary() as? [String : AnyObject], encoding: .JSON)
            .responseJSON { response in
//                debugPrint(response.request)
//                debugPrint(response)
                switch response.result {
                case .Success:
                    let timeEntryModel = TimeEntryModel.init(fromDictionary: self.convertDataToDictionary(response.data!)!)
                    let timeEntry : TimeEntry = timeEntryModel.data!
                    AnswersTracking.trackEventStartEntrySuccess(timeEntry)
                    success(timeEntry)
                case .Failure(let error):
                    print(error)
                    failure(error.debugDescription)
                }
        }
    }
    
    // MARK: Support functions
    func stopCurrentTimeEntry(success:()->Void, failure:(String)->Void) {
        getCurrentEntry({(result) in
            if result != nil {
                self.stopEntry("\(result!.id!)", success: { (response) -> Void in
                        success()
                        AnswersTracking.trackEventStopCurrentEntrySuccess(result!)
                    }, failure: { (error) -> Void in
                        print(error)
                        AnswersTracking.trackEventStopCurrentEntryFailure(result!, error: error.debugDescription)
                        failure(error.debugDescription)
                })
            }else{
                failure("")
            }
            },
            failure: {(error) in
                print(error)
                failure(error.debugDescription)
        })
    }
    
    func startLastTimeEntry(success:()->Void, failure:(String)->Void) {
        getUserInfo({(result) in
            if result.data.timeEntries.count>0{
                let lastTimeEntry = result.data.timeEntries.last!
                if lastTimeEntry.stop != nil {
                    let startTimeEntry = lastTimeEntry
                    startTimeEntry.stop=nil
                    startTimeEntry.id=nil
                    startTimeEntry.guid=nil
                    startTimeEntry.createdWith="Leto Toggl iOS"
                    startTimeEntry.start = AppUtils.ISOStringFromDate(NSDate())
                    startTimeEntry.duration = Int(-NSDate().timeIntervalSince1970)
                    let startEntryModel = StartTimeEntryModel(fromEntry: startTimeEntry)
                    self.startEntry(startEntryModel, success: { (response) -> Void in
                        success()
                        AnswersTracking.trackEventStartLastEntrySuccess(startTimeEntry)
                        }, failure: { (error) -> Void in
                            print(error)
                            AnswersTracking.trackEventStartLastEntryFailure(startTimeEntry, error: error.debugDescription)
                            failure(error.debugDescription)
                    })
                }else{
                    success()
                }
            }else{
                self.startTimeEntry(entryName: "-", project:Project.init(name: "-", color: "15"), billable: false, success: {
                    success()
                    }, failure: { (error) in
                        failure(error.debugDescription)
                })
            }
            },
            failure: {(error) in
                print(error)
                failure(error.debugDescription)
        })
    }
    
    func startTimeEntry(entryName name:String, project:Project, billable:Bool,success:()->Void, failure:(String)->Void) {
        let startTimeEntry = TimeEntry()
        startTimeEntry.descriptionField = name
        startTimeEntry.pid = project.id
        startTimeEntry.billable = billable
        startTimeEntry.stop=nil
        startTimeEntry.id=nil
        startTimeEntry.guid=nil
        startTimeEntry.createdWith="Leto Toggl iOS"
        startTimeEntry.start = AppUtils.ISOStringFromDate(NSDate())
        startTimeEntry.duration = Int(-NSDate().timeIntervalSince1970)
        let startEntryModel = StartTimeEntryModel(fromEntry: startTimeEntry)
        self.startEntry(startEntryModel, success: { (response) -> Void in
            success()
            AnswersTracking.trackEventStartLastEntrySuccess(startTimeEntry)
            }, failure: { (error) -> Void in
                print(error)
                AnswersTracking.trackEventStartLastEntryFailure(startTimeEntry, error: error.debugDescription)
                failure(error.debugDescription)
        })
    }
    
    func getProjectsList(workspaceID wid:Int, success:([Project])->Void, failure:(String)->Void) {
        Alamofire.request(.GET, "\(BASE_URL)/workspaces/\(wid)/projects", headers: headers, parameters: nil)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    var json: Array<[String:AnyObject]>!
                    do {
                        json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions()) as? Array
                    } catch {
                        print(error)
                    }
                    var projects : [Project] = Array()
                    for item : [String: AnyObject] in json{
                        let project = Project.init(fromDictionary: item)
                        projects.append(project)
                    }
                    success(projects)
                case .Failure(let error):
                    print(error)
                    failure(error.debugDescription)
                }
        }
    }
    
    func getClientsList(workspaceID wid:Int, success:([Client])->Void, failure:(String)->Void) {
        Alamofire.request(.GET, "\(BASE_URL)/workspaces/\(wid)/clients", headers: headers, parameters: nil)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    var json: Array<[String:AnyObject]>!
                    do {
                        json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions()) as? Array
                    } catch {
                        print(error)
                    }
                    var clients : [Client] = Array()
                    for item : [String: AnyObject] in json{
                        let project = Client.init(fromDictionary: item)
                        clients.append(project)
                    }
                    success(clients)
                case .Failure(let error):
                    print(error)
                    failure(error.debugDescription)
                }
        }
    }
    
    func getProjectsListWithClientInfo(workspaceID wid:Int, success:([Project])->Void, failure:(String)->Void) {
        Alamofire.request(.GET, "\(BASE_URL)/workspaces/\(wid)/projects", headers: headers, parameters: nil)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    var json: Array<[String:AnyObject]>!
                    do {
                        json = try NSJSONSerialization.JSONObjectWithData(response.data!, options: NSJSONReadingOptions()) as? Array
                    } catch {
                        print(error)
                    }
                    var projects : [Project] = Array()
                    for item : [String: AnyObject] in json{
                        let project = Project.init(fromDictionary: item)
                        projects.append(project)
                    }
                    
                    self.getClientsList(workspaceID: wid, success: { (clients) in
                        for client in clients{
                            for  proj in projects {
                                if proj.cid == client.id {
                                    proj.clientObj = client
                                }
                            }
                        }
                        success(projects)
                        }, failure: { (error) in
                            print(error)
                            failure(error.debugDescription)
                    })
                    
                case .Failure(let error):
                    print(error)
                    failure(error.debugDescription)
                }
        }
    }

    
    private func convertDataToDictionary(data: NSData) -> [String:AnyObject]? {
            do {
                return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
            } catch {
                return nil;
            }
    }

}