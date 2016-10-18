//
//  ProjectsListController.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 01/08/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

class ProjectsListController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var tableView: WKInterfaceTable!
    
    var projects : [Project] = []
    
    static var selectedProj:Project?
    
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
        super.willActivate()
        getProjects()
    }
    
    private func getProjects() {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session!.sendMessage(["request": WatchConnectivityUtil.REQUEST_PROJECTS], replyHandler: { (response) -> Void in
                if response[WatchConnectivityUtil.PROJECTS_LIST] as? [[String:AnyObject]] != nil{
                    for dict:[String:AnyObject]  in (response[WatchConnectivityUtil.PROJECTS_LIST] as? [[String:AnyObject]])!{
                        self.projects.append(Project.init(fromDictionary:dict))
                    }
                    
                    self.tableView.setNumberOfRows(self.projects.count, withRowType: "ProjectRow")
                    for index in 0..<self.tableView.numberOfRows {
                        if let controller = self.tableView.rowControllerAtIndex(index) as? ProjectsRowController {
                            controller.project =  self.projects[index]
                        }
                    }
                }else{
                    self.tableView.setNumberOfRows(0, withRowType: "ProjectRow")
                }
                }, errorHandler: { (error) -> Void in
                    print(error)
            })
        }
    }
    
    override func table(table: WKInterfaceTable, didSelectRowAtIndex rowIndex: Int) {
        ProjectsListController.selectedProj = projects[rowIndex]
        dismissController()
    }
}
