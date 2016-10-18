//
//  NewTaskViewController.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 28/07/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation
import NBMaterialDialogIOS

class NewTaskViewController: BaseTableViewController, UITextFieldDelegate{

    
    @IBOutlet weak var taskName: UITextField!
    @IBOutlet weak var projName: UILabel!
    @IBOutlet weak var billableSwitch: UISwitch!
    
    var selectedProj = Project.init(name: "-", color: "15"){
        didSet{
            projName.text = selectedProj.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createHeaderWithTitle("TASK DETAILS")
    }
    
    
    @IBAction func startAction(sender: AnyObject) {
        view.endEditing(true)
        let newTaskName = (taskName.text == "" ? "-" : taskName.text!)
        print("NAME = \(newTaskName)  PROJ = \(selectedProj.name!)  BILLABLE = \(billableSwitch.on)")
        LoadingView.sharedInstance.show(self.view)
        let startTimeEntry = TimeEntry()
        startTimeEntry.descriptionField = newTaskName
        startTimeEntry.pid = selectedProj.id
        startTimeEntry.billable = billableSwitch.on
        startTimeEntry.stop=nil
        startTimeEntry.id=nil
        startTimeEntry.guid=nil
        startTimeEntry.createdWith="Leto Toggl iOS"
        startTimeEntry.start = AppUtils.ISOStringFromDate(NSDate())
        startTimeEntry.duration = Int(-NSDate().timeIntervalSince1970)
        let startEntryModel = StartTimeEntryModel(fromEntry: startTimeEntry)
        LetoTogglRestClient.sharedInstance.startEntry(startEntryModel, success: { (response) -> Void in
            if let navController = self.navigationController {
                LoadingView.sharedInstance.hide()
                navController.popViewControllerAnimated(true)
            }
            }, failure: { (error) -> Void in
                LoadingView.sharedInstance.hide()
                AnswersTracking.trackEventStartEntryFailure(startTimeEntry,error: error.debugDescription)
                NBMaterialSnackbar.showWithText(self.view, text: NSLocalizedString("localized_no_internet", comment: ""), duration: NBLunchDuration.LONG)
        })    }
}
