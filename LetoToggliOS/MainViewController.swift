//
//  MainViewController.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 08/03/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation
import Kingfisher
import NBMaterialDialogIOS
import Crashlytics

class MainViewController: BaseViewController {
    
    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var timeEntries : [TimeEntry]!
    var currentTimeEntry : TimeEntry?
    var lastTrackedTimeEntry : TimeEntry!
    var userInfo : TogglUser!
    
    //Current task
    @IBOutlet weak var currentTaskName: UILabel!
    @IBOutlet weak var currentTaskDetails: UILabel!
    @IBOutlet weak var currentTaskDuration: UILabel!
    
    //Last tracked task
    @IBOutlet weak var lastTaskName: UILabel!
    @IBOutlet weak var lastTaskDuration: UILabel!
    @IBOutlet weak var lastTaskDetails: UILabel!
    
    var timer = NSTimer()
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    var refreshControl : UIRefreshControl!
    
    @IBOutlet weak var weekTotalLabel: UILabel!
    @IBOutlet weak var barChart: BarChartView!
    
    @IBOutlet weak var stopImage: UIImageView!
    @IBOutlet weak var playImage: UIImageView!
    
    @IBOutlet weak var beaconStatusIndicator: UIImageView!
    
    //PROJECTS
    @IBOutlet weak var projectsContainerView: UIView!
    @IBOutlet weak var projectsContainerHeightConstraint: NSLayoutConstraint!
    let PROJECT_VIEW_HEIGHT : CGFloat = 40
    
    internal var isFrom3dTouch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainViewController.handleNotif(_:)), name: AppPreferences.NEED_UPDATE_NOTIF, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        getUserInfo()
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        AnswersTracking.trackEventScreen("MainViewController Will Appear")
        addForceTouch()
        if isFrom3dTouch {
            isFrom3dTouch = false
            performSegueWithIdentifier("goToNewTask", sender: self)
        }
    }
    
    func addForceTouch(){
        let addShortCut = UIApplicationShortcutItem.init(type:AppDelegate.NEW_TASK_QUICK_ACTION, localizedTitle:  "Start a new task", localizedSubtitle: nil, icon: UIApplicationShortcutIcon.init(type: UIApplicationShortcutIconType.Compose), userInfo: nil)
        UIApplication.sharedApplication().shortcutItems = [addShortCut]
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func handleNotif(notif: NSNotification) {
        getUserInfo()
    }

    func handleRefresh(refreshControl: UIRefreshControl) {
        getUserInfo()
    }
    
    func getUserInfo(){
        LetoTogglRestClient.sharedInstance.getUserInfo(
            {(result:TogglUser) in
                self.userInfo=result
                self.refreshControl.endRefreshing()
                self.timeEntries = AppUtils.createCompleteEntriesModel(result.data.timeEntries, projects: result.data.projects, clients: result.data.clients)
                if  self.timeEntries.count > 0 {
                    let lastEntry = self.timeEntries.last!
                    if lastEntry.stop != nil {
                        self.currentTimeEntry=nil
                        self.lastTrackedTimeEntry = lastEntry
                    }else{
                        self.currentTimeEntry=lastEntry
                        if self.timeEntries.count>=2{
                            self.lastTrackedTimeEntry=self.timeEntries[self.timeEntries.count-2]
                        }
                        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: #selector(MainViewController.updateCounter), userInfo: nil, repeats: true)
                        
                    }
                }
                if self.userInfo.data.workspaces.count > 0 {
                    AppPreferences.setWorksapceID(self.userInfo.data.workspaces[0].id)
                }
                self.setupUser(result)
                self.setupWeek()
            },
            failure: {(error:String) in
                LoadingView.sharedInstance.hide()
                self.refreshControl.endRefreshing()
                NBMaterialSnackbar.showWithText(self.view, text: NSLocalizedString("localized_no_internet", comment: ""), duration: NBLunchDuration.LONG)
        })
        
        if let state = AppPreferences.getDetectionState() as! String?{
            switch state{
            case DetectionState.OnDetectionBeacon.rawValue:
                beaconStatusIndicator.hidden=false
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                if appDelegate.beaconDetected {
                    beaconStatusIndicator.image=UIImage.init(named: "online")
                }else{
                    beaconStatusIndicator.image=UIImage.init(named: "offline")
                }
                
                break
            case DetectionState.OnDetectionGeofence.rawValue:
                beaconStatusIndicator.hidden=true
                break
            case DetectionState.OnNonDetection.rawValue:
                beaconStatusIndicator.hidden=true
                break
            default:
                break
            }
        }
    }
    
    func initUI(){
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MainViewController.handleRefresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        mainScrollView.addSubview(refreshControl)
        LoadingView.sharedInstance.show(self.view)
        stopImage.hidden=true
        playImage.hidden=true
        stopImage.bounds = CGRectInset(stopImage.frame, 10.0, 10.0);
//        view.bounds = CGRectInset(view.frame, 10.0f, 10.0f);
        beaconStatusIndicator.hidden=true
    }
    
    func updateCounter() {
        if currentTimeEntry != nil{
            AppUtils.setDurationLabel((currentTimeEntry?.duration)!, label: currentTaskDuration)
        }
    }
    
    func setupWeek(){
        let today = NSDate()
        let todayIso = AppUtils.ISOStringFromDate(today)
        let cal: NSCalendar = NSCalendar.currentCalendar()
        let comp: NSDateComponents = cal.components([.Weekday,.Hour], fromDate: today)
        let dayOfTheWeek = comp.weekday
        let weekFirstDay = today.dateByAddingTimeInterval(NSTimeInterval(-60*60*24*dayOfTheWeek-comp.hour))
        LetoTogglRestClient.sharedInstance.getTimeEntries(AppUtils.ISOStringFromDate(weekFirstDay), endDate: todayIso,
            success: { (result) -> Void in
                AppUtils.createCompleteEntriesModel(result, projects: self.userInfo.data.projects, clients: self.userInfo.data.clients)
                self.setupWeekProjects(result)
                self.setupWeekPlot(result)
        },
            failure:{ (error) -> Void in
                LoadingView.sharedInstance.hide()
                self.refreshControl.endRefreshing()
                NBMaterialSnackbar.showWithText(self.view, text: NSLocalizedString("localized_no_internet", comment: ""), duration: NBLunchDuration.LONG)
        })
    }
    
    func setupUser(user:TogglUser){
        // User Info
        if user.data.imageUrl != "https://assets.toggl.com/images/profile.png" {
            profileIV.kf_setImageWithURL(NSURL(string: user.data.imageUrl)!, placeholderImage: UIImage(named: "profile_ph"))
        }
        //        profileIV.layer.borderWidth = 1
        profileIV.layer.masksToBounds = false
        //        profileIV.layer.borderColor = UIColor.blackColor().CGColor
        profileIV.layer.cornerRadius = profileIV.frame.height/2
        profileIV.clipsToBounds = true
        nameLabel.text="Hello \(user.data.fullname)!"

        //Current task
        if currentTimeEntry != nil {
            currentTaskName.text=currentTimeEntry?.descriptionField
            AppUtils.setDurationLabel((currentTimeEntry?.duration)!, label: currentTaskDuration)
            AppUtils.setupDescriptionLabel(currentTaskDetails, timeEntry: currentTimeEntry!)
            stopImage.hidden=false
        }else{
            currentTaskName.text=NSLocalizedString("localized_no_current",comment:"")
            currentTaskDuration.text=""
            currentTaskDetails.text=""
            currentTaskDetails.backgroundColor = MainPalette.transparentColor()
            stopImage.hidden=true
        }
        
        //Last task
        if lastTrackedTimeEntry != nil {
            lastTaskName.text=lastTrackedTimeEntry.descriptionField
            AppUtils.setDurationLabel((lastTrackedTimeEntry?.duration)!, label: lastTaskDuration)
            AppUtils.setupDescriptionLabel(lastTaskDetails, timeEntry: lastTrackedTimeEntry)
            playImage.hidden=false
        }else{
            lastTaskName.text="-"
            lastTaskDuration.text="-"
            lastTaskDetails.text="-"
            lastTaskDetails.backgroundColor = MainPalette.transparentColor()
            playImage.hidden=true

        }
        
    }
    
    func setupWeekPlot(result:[TimeEntry]){
        let cal: NSCalendar = NSCalendar.currentCalendar()
        var totalWeekTime = 0
        var dayByDayDuration = [[Double]?](count: 7, repeatedValue: [0])
        var dayByDayColors = [[NSUIColor]](count: 7, repeatedValue: [MainPalette.accentColor()])
        
        for entry:TimeEntry in result{
            if entry.duration>0 {
                totalWeekTime += entry.duration
                let entryStartDate = AppUtils.dateFromISOString(entry.start)
                let component : NSDateComponents = cal.components(.Weekday, fromDate: entryStartDate)
                dayByDayDuration[component.weekday-1]!.append(Double(entry.duration))
                
                var color = MainPalette.accentColor()
                if let projectColor = entry.projectObj?.color{
                    let colorIndex:Int = Int(projectColor)!
                    color = AppUtils.getColorFromIndex(colorIndex)
                }
                dayByDayColors[component.weekday-1].append(color)
            }
        }
        if totalWeekTime>0{
            AppUtils.setDurationLabel(totalWeekTime, label: self.weekTotalLabel)
        }
        LoadingView.sharedInstance.hide()

        
        
        
        let xVals = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        var yVals = Array<BarChartDataEntry>()
        
        for i in 0 ..< dayByDayDuration.count {
            yVals.append(BarChartDataEntry.init(values: dayByDayDuration[i]!, xIndex: i))
        }
     
        let set1 = BarChartDataSet.init(yVals: yVals, label: "Dataset")
        set1.barSpace=0.35
        
        var dataSets = Array<BarChartDataSet>()
        dataSets.append(set1)
        
        let data = BarChartData.init(xVals: xVals, dataSets: dataSets)
        // PLOT UI
        set1.colors=[MainPalette.accentColor()]
        set1.useStackedColors=true
        set1.stackedColors=dayByDayColors
        set1.barShadowColor=MainPalette.transparentColor()
        
        barChart.legend.enabled=false
        barChart.descriptionText=""
        barChart.userInteractionEnabled=false
        barChart.noDataText="No data"

        let xl = barChart.xAxis
        xl.labelPosition=ChartXAxis.LabelPosition.Bottom
        xl.avoidFirstLastClippingEnabled=true
        xl.spaceBetweenLabels=1
        xl.drawGridLinesEnabled=false
        xl.axisLineColor=MainPalette.lightGreyTextColor()
        
        
        let yLeftAxis = barChart.leftAxis
        yLeftAxis.axisMinValue=0
        yLeftAxis.axisLineColor=UIColor.clearColor()
        
        yLeftAxis.valueFormatter=MyFormatter()
        yLeftAxis.gridColor=MainPalette.lightGreyTextColor()
        
        let yRightAxis = barChart.rightAxis
        yRightAxis.enabled=false

        barChart.data = data;
        barChart.barData?.setDrawValues(false);
    }
    
    class MyFormatter:NSNumberFormatter {

        override init() {
            super.init()
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func stringForObjectValue(obj: AnyObject) -> String? {
            let duration = obj as! Int
            let hours : Int = duration/3600
            var remainder : Int = duration - hours * 3600
            let mins : Int = remainder/60
            remainder = remainder - mins * 60
            
            return "\(hours) h \(mins) m"

        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goToMonth") {
            // pass data to next view
            let destVC = segue.destinationViewController as! MonthViewController
            destVC.projects=userInfo.data.projects
            destVC.clients=userInfo.data.clients
            AnswersTracking.trackEventCheckLast30Days()
        }
        if (segue.identifier == "goToMore") {
            // pass data to next view
            let destVC = segue.destinationViewController as! MoreViewController
            destVC.projects=userInfo.data.projects
            destVC.clients=userInfo.data.clients
        }
    }
    
    
    @IBAction func stopPressed(sender: AnyObject) {
        if stopImage.hidden==false{
        LoadingView.sharedInstance.show(self.view)
        LetoTogglRestClient.sharedInstance.stopEntry("\(currentTimeEntry!.id!)",
            success: { (result) -> Void in
                self.getUserInfo()
            }) { (error) -> Void in
                LoadingView.sharedInstance.hide()
                NBMaterialSnackbar.showWithText(self.view, text: NSLocalizedString("localized_no_internet", comment: ""), duration: NBLunchDuration.LONG)
        }
        }
    }
    
    @IBAction func playPressed(sender: AnyObject) {
        if playImage.hidden==false{
        LoadingView.sharedInstance.show(self.view)
            let startTimeEntry = lastTrackedTimeEntry
            startTimeEntry.stop=nil
            startTimeEntry.id=nil
            startTimeEntry.guid=nil
            startTimeEntry.createdWith="Leto Toggl iOS"
            startTimeEntry.start = AppUtils.ISOStringFromDate(NSDate())
            startTimeEntry.duration = Int(-NSDate().timeIntervalSince1970)
            let startEntryModel = StartTimeEntryModel(fromEntry: startTimeEntry)
            LetoTogglRestClient.sharedInstance.startEntry(startEntryModel, success: { (response) -> Void in
                    self.getUserInfo()
                }, failure: { (error) -> Void in
                    LoadingView.sharedInstance.hide()
                    AnswersTracking.trackEventStartEntryFailure(startTimeEntry,error: error.debugDescription)
                    NBMaterialSnackbar.showWithText(self.view, text: NSLocalizedString("localized_no_internet", comment: ""), duration: NBLunchDuration.LONG)
            })
        }
    }
    
    func setupWeekProjects(result:[TimeEntry]){
        var projectDurations = [Int]()
        var projectColors = [NSUIColor]()
        var projectNames = [String]()

        for entry:TimeEntry in result{
            if entry.duration>0 {
                var itemIndex = -1;
                if entry.projectObj == nil {
                    continue
                }else{
                    for proj in projectNames{
                        if entry.projectObj?.name == proj {
                            itemIndex = projectNames.indexOf(proj)!
                            break
                        }
                    }
                }
                
                var color = MainPalette.accentColor()
                if let projectColor = entry.projectObj?.color{
                    let colorIndex:Int = Int(projectColor)!
                    color = AppUtils.getColorFromIndex(colorIndex)
                }
                
                if itemIndex == -1 {
                    projectNames.append((entry.projectObj?.name)!)
                    projectColors.append(color)
                    projectDurations.append(entry.duration)
                }else{
                    projectNames[itemIndex]=(entry.projectObj?.name)!
                    projectColors[itemIndex]=color
                    projectDurations[itemIndex] += entry.duration
                }
            }
        }
        
        addProjectToWeekList(projectDurations, projectColors: projectColors, projectNames: projectNames)
    }
    
    func addProjectToWeekList(projectDuration:[Int], projectColors:[NSUIColor], projectNames:[String]){
        // Clear view
        for projView in projectsContainerView.subviews {
            projView.removeFromSuperview()
            projectsContainerHeightConstraint.constant=0
        }
        // Add subviews
        if projectNames.count>0{
            for i in 0...projectNames.count-1 {
                let newProject = ProjectView(frame: CGRect(x: 0, y: PROJECT_VIEW_HEIGHT * CGFloat(projectsContainerView.subviews.count), width: projectsContainerView.frame.size.width, height: PROJECT_VIEW_HEIGHT))
                newProject.projectLabel?.text = projectNames[i]
                newProject.projectLabel?.backgroundColor = projectColors[i]
                AppUtils.setDurationLabel(projectDuration[i], label: newProject.timeLabel!)
                projectsContainerView.addSubview(newProject)
            }
        }else{
            let noProjLabel = UILabel(frame: CGRect(x: 8, y: PROJECT_VIEW_HEIGHT * CGFloat(projectsContainerView.subviews.count), width: projectsContainerView.frame.size.width, height: PROJECT_VIEW_HEIGHT))
            noProjLabel.text = NSLocalizedString("localized_no_projects", comment: "")
            projectsContainerView.addSubview(noProjLabel)
        }
        projectsContainerHeightConstraint.constant = PROJECT_VIEW_HEIGHT * CGFloat(projectsContainerView.subviews.count)
        self.view.setNeedsLayout()
    }
}