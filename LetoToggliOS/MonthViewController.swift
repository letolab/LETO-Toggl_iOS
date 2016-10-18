//
//  MonthViewController.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 11/03/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation
import NBMaterialDialogIOS

class MonthViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    var data = [TimeEntry]()
    var projects : [Project]!
    var clients : [Client]!
    var refreshControl = UIRefreshControl()
    var dataBySections = [[TimeEntry]]()
    var sectionsName = [String]()
    
    let HEADER_HEIGHT : CGFloat = 50

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        getEntries()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        AnswersTracking.trackEventScreen("MonthViewController Will Appear")
    }
    
    func initUI(){
        LoadingView.sharedInstance.show(self.view)
        refreshControl.addTarget(self, action: #selector(MonthViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        getEntries()
    }
    
    func getEntries(){
        let today = NSDate()
        let todayIso = AppUtils.ISOStringFromDate(today)
        let monthAgoFirstDay = today.dateByAddingTimeInterval(NSTimeInterval(-60*60*24*30))
        LetoTogglRestClient.sharedInstance.getTimeEntries(AppUtils.ISOStringFromDate(monthAgoFirstDay), endDate: todayIso,
            success: { (result) -> Void in
                self.refreshControl.endRefreshing()
                LoadingView.sharedInstance.hide()
                self.data = AppUtils.createCompleteEntriesModel(result, projects: self.projects, clients: self.clients)
                self.data=self.data.reverse()
                self.createSections()
                self.tableView.reloadData()
            },
            failure:{ (error) -> Void in
                                LoadingView.sharedInstance.hide()
                                self.refreshControl.endRefreshing()
                                NBMaterialSnackbar.showWithText(self.view, text: NSLocalizedString("localized_no_internet", comment: ""), duration: NBLunchDuration.LONG)
        })
    }
    
    func createSections(){
        for entry:TimeEntry in self.data{
            if entry.duration>0 {
                var itemIndex = -1
                let entryStartDate = AppUtils.dateStringFromISOString(entry.start)
                
                for date in sectionsName{
                    if entryStartDate == date {
                        itemIndex = sectionsName.indexOf(date)!
                        break
                    }
                }
                
                if itemIndex == -1 {
                    sectionsName.append(entryStartDate)
                    var newSection = [TimeEntry]()
                    newSection.append(entry)
                    dataBySections.append(newSection)
                }else{
                    dataBySections[itemIndex].append(entry)
                }
            }
        }
    }
    
    
// MARK TableView delegate and data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataBySections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int)  -> Int {
        return dataBySections[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TimeEntryCell", forIndexPath: indexPath) as! TimeEntryCell

        let timeEntryObj = dataBySections[indexPath.section][indexPath.row]
        
        
        cell.entryName.text=timeEntryObj.descriptionField
        AppUtils.setDurationLabel(timeEntryObj.duration!, label: cell.entryDuration)
        AppUtils.setupDescriptionLabel(cell.entryDetails, timeEntry: timeEntryObj)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return HEADER_HEIGHT
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: HEADER_HEIGHT))
        headerView.backgroundColor = UIColor.whiteColor()
        
        let leftMargin :CGFloat = 16
        let titleLabel = UILabel(frame: CGRect(x: leftMargin, y: 0, width: tableView.frame.size.width - leftMargin, height: HEADER_HEIGHT))
        titleLabel.font = UIFont.systemFontOfSize(13, weight: UIFontWeightBold)
        titleLabel.textColor = UIColor.lightGrayColor()
        titleLabel.text = sectionsName[section]
        
        headerView.addSubview(titleLabel)
        
        return headerView
    }
}