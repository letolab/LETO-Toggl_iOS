//
//  AppDelegate.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 03/03/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import UIKit
import CoreLocation
import Fabric
import Crashlytics
import WatchConnectivity

@UIApplicationMain
class AppDelegate: WatchCommunication, UIApplicationDelegate{
    
    var window: UIWindow?
    var locationManager: CLLocationManager?
    var lastProximity: CLProximity?
    var beaconRegion:CLBeaconRegion!
    var geofenceRegion:CLCircularRegion!
    var stateDeterminated = false
    var beaconDetected = false
    var geolocationDetected = false
    var isBeaconListenerActive = false
    var isGeofenceListenerActive = false
    
    var lastNotfDate : NSDate?
    let MIN_SEC_NOTF = 5
    
    static let NEW_TASK_QUICK_ACTION  = "com.leto.toggl.newtask.action"
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
        }
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil))
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        Fabric.with([Crashlytics.self])
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        checkIfUserIsLoggedIn()
        configureNullStateSnooze()
        checkPreviousDetectionState()
        AppPreferences.setSnooze(false)
        application.cancelAllLocalNotifications()
        if let state = AppPreferences.getDetectionState() as! String?{
            switch state{
            case DetectionState.OnDetectionBeacon.rawValue:
                setupBeaconListener()
                break
            case DetectionState.OnDetectionGeofence.rawValue:
                setupGeotificationListener()
                break
            case DetectionState.OnNonDetection.rawValue:
                print("No detection state")
                break
            default:
                break
            }
        }
        return true
    }
    
    func setupGeotificationListener (){
        isGeofenceListenerActive = true
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.requestAlwaysAuthorization()
        locationManager!.requestWhenInUseAuthorization()
        locationManager!.startUpdatingLocation()
        locationManager!.distanceFilter = kCLDistanceFilterNone
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        
        if let geotification = AppPreferences.getGeotification() as Geotification!{
            //print("radius \(geotification.radius)")
            geofenceRegion = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: "Leto Toggl region")
            locationManager!.startMonitoringForRegion(geofenceRegion)
        }
        
        
    }
    
    func stopGeotificationListener(){
        isGeofenceListenerActive = false
        if locationManager != nil{
            locationManager!.stopMonitoringForRegion(geofenceRegion)
            locationManager!.stopUpdatingLocation()
        }
    }
    
    func setupBeaconListener(){
        isBeaconListenerActive = true
        let application=UIApplication.sharedApplication()
        let uuidString = AppPreferences.getBeaconUuid() as! String
        let beaconIdentifier = "Leto Toggl region"
        let beaconUUID:NSUUID = NSUUID(UUIDString: uuidString)!
        beaconRegion = CLBeaconRegion(proximityUUID: beaconUUID, identifier: beaconIdentifier)
        
        locationManager = CLLocationManager()
        if(locationManager!.respondsToSelector(#selector(CLLocationManager.requestAlwaysAuthorization))) {
            locationManager!.requestAlwaysAuthorization()
        }
        locationManager!.delegate = self
        locationManager!.pausesLocationUpdatesAutomatically = false
        
        locationManager!.startMonitoringForRegion(beaconRegion)
        stateDeterminated = false
        
        
        if(application.respondsToSelector(#selector(UIApplication.registerUserNotificationSettings(_:)))) {
            application.registerUserNotificationSettings(
                UIUserNotificationSettings(
                    forTypes: [UIUserNotificationType.Alert , UIUserNotificationType.Sound],
                    categories: nil
                )
            )
        }
        
    }
    
    func stopBeaconListener(){
        if locationManager != nil{
            locationManager!.stopMonitoringForRegion(beaconRegion)
            locationManager!.stopUpdatingLocation()
            locationManager!.stopRangingBeaconsInRegion(beaconRegion)
            isBeaconListenerActive = false
        }
    }
    
    func checkIfUserIsLoggedIn(){
        if let apiToken = AppPreferences.getApiToken(){
            if apiToken as! String != "" {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let mainVC = mainStoryboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
                let rootViewController = self.window!.rootViewController as! UINavigationController
                rootViewController.pushViewController(mainVC, animated: false)
            }
        }
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        print(shortcutItem.type)
        if shortcutItem.type == AppDelegate.NEW_TASK_QUICK_ACTION {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let mainVC = mainStoryboard.instantiateViewControllerWithIdentifier("MainViewController") as! MainViewController
            let rootViewController = self.window!.rootViewController as! UINavigationController
            mainVC.isFrom3dTouch = true
            rootViewController.pushViewController(mainVC, animated: false)
        }
    }
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        application.applicationIconBadgeNumber = 0
        //print("RECEIVE LOCAL NOTIFICATION)")
        application.cancelAllLocalNotifications()
        AppPreferences.setSnooze(false)
    }
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        
        // Handle notification action *****************************************
        if notification.category == "TIMER_CATEGORY" {
            
            if identifier == "STOP_TIMER" {
                print("STOP TOGGL")
                AppPreferences.setSnooze(false)
                LetoTogglRestClient.sharedInstance.stopCurrentTimeEntry({ () -> Void in
                    self.sendLocalNotificationWithMessage("Toggl Tracker stopped", playSound: false, showActions: true)
                    NSNotificationCenter.defaultCenter().postNotificationName(AppPreferences.NEED_UPDATE_NOTIF, object: nil)
                    //Call the completionHandler after the server replyes
                    completionHandler()
                }) { (error) -> Void in
                    //do nothing
                    self.sendLocalNotificationWithMessage("I am not able to stop your time tracker, please check your internet connection", playSound: false, showActions: false)
                }
                
            }
            
            if identifier == "SNOOZE_TIMER10" {
                //stop timer but issue another notification in 10 minutes to remind the user to start tracking time
                LetoTogglRestClient.sharedInstance.stopCurrentTimeEntry({ () -> Void in
                    self.sendLocalNotificationWithMessage("Toggl stopped. Will remind you to start and enable tracking in 10 minutes!", playSound: false, showActions: true)
                    AppPreferences.setSnooze(true)
                    self.sendLocalNotificationWithMessageAfterGivenTime("Reminder: Enable detection or start Toggl task", playSound: false, minutes: 10.0)
                    self.sendLocalNotificationWithMessageAfterGivenTime("Reminder: Enable detection or start Toggl task", playSound: false, minutes: 30.0)
                    self.sendLocalNotificationWithMessageAfterGivenTime("Reminder: Enable detection or start Toggl task", playSound: false, minutes: 120.0)
                    NSNotificationCenter.defaultCenter().postNotificationName(AppPreferences.NEED_UPDATE_NOTIF, object: nil)
                    //Call the completionHandler after the server replyes
                    completionHandler()
                }) { (error) -> Void in
                    //do nothing
                    self.sendLocalNotificationWithMessage("I am not able to stop your time tracker, please check your internet connection", playSound: false, showActions: false)
                }
                
            }
            
            if identifier == "SNOOZE_TIMER30" {
                //stop timer but issue another notification in 10 minutes to remind the user to start tracking time
                LetoTogglRestClient.sharedInstance.stopCurrentTimeEntry({ () -> Void in
                    self.sendLocalNotificationWithMessage("Toggl stopped. Will remind you to start and enable tracking in 30 minutes!", playSound: false, showActions: true)
                    
                    AppPreferences.setSnooze(true)
                    self.sendLocalNotificationWithMessageAfterGivenTime("Reminder: Enable detection or start Toggl task", playSound: false, minutes: 30.0)
                    self.sendLocalNotificationWithMessageAfterGivenTime("Reminder: Enable detection or start Toggl task", playSound: false, minutes: 60.0)
                    self.sendLocalNotificationWithMessageAfterGivenTime("Reminder: Enable detection or start Toggl task", playSound: false, minutes: 120.0)
                    
                    
                    NSNotificationCenter.defaultCenter().postNotificationName(AppPreferences.NEED_UPDATE_NOTIF, object: nil)
                    //Call the completionHandler after the server replyes
                    completionHandler()
                }) { (error) -> Void in
                    //do nothing
                    self.sendLocalNotificationWithMessage("I am not able to stop your time tracker, please check your internet connection", playSound: false, showActions: false)
                }
                
            }
            
            if identifier == "STOP_SNOOZE" {
                AppPreferences.setSnooze(false)
                application.cancelAllLocalNotifications()
                self.sendLocalNotificationWithMessage("Location detection is enabled", playSound: false, showActions: true)
            }
            
            
            if identifier ==  "START_TIMER"{
                AppPreferences.setSnooze(false)
                application.cancelAllLocalNotifications()
                if lastNotfDate == nil || Int(NSDate().timeIntervalSinceDate(lastNotfDate!)) > MIN_SEC_NOTF {
                    self.lastNotfDate = NSDate()
                    LetoTogglRestClient.sharedInstance.startLastTimeEntry({ () -> Void in
                        self.lastNotfDate = NSDate()
                        self.sendLocalNotificationWithMessageAndButton("Toggl tracker started", playSound: false)
                        NSNotificationCenter.defaultCenter().postNotificationName(AppPreferences.NEED_UPDATE_NOTIF, object: self)
                        completionHandler()
                    }) { (error) -> Void in
                        //do nothing
                        self.sendLocalNotificationWithMessage("I am not able to start your time tracker, please check your internet connection", playSound: false, showActions: false)
                    }
                }
            }
            
        }
    }
    
}

extension AppDelegate: CLLocationManagerDelegate {
    
    func sendLocalNotificationWithMessage(message: String!, playSound: Bool, showActions:Bool) {
        
        // Category
        let timerCategory = UIMutableUserNotificationCategory()
        timerCategory.identifier = "TIMER_CATEGORY"
        
        if showActions {
            let startAction = UIMutableUserNotificationAction()
            startAction.identifier = "START_TIMER"
            startAction.title = "START"
            startAction.activationMode = UIUserNotificationActivationMode.Background
            startAction.authenticationRequired = false
            startAction.destructive = false
            
            
            
            // A. Set actions for the default context
            timerCategory.setActions([startAction],
                                     forContext: UIUserNotificationActionContext.Default)
            
            // B. Set actions for the minimal context
            timerCategory.setActions([startAction],
                                     forContext: UIUserNotificationActionContext.Minimal)
        }
        
        
        
        // 3. Notification Registration *****************************************
        
        let types = UIUserNotificationType.Alert
        let settings = UIUserNotificationSettings(forTypes: types, categories: NSSet(object: timerCategory) as? Set<UIUserNotificationCategory>)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertBody = message
        localNotification.category = "TIMER_CATEGORY"
        
        if(playSound) {
            // classic star trek communicator beep
            //	http://www.trekcore.com/audio/
            //
            // note: convert mp3 and wav formats into caf using:
            //	"afconvert -f caff -d LEI16@44100 -c 1 in.wav out.caf"
            // http://stackoverflow.com/a/10388263
            
            localNotification.soundName = "tos_beep.caf";
        }
        
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    /**
     *  Show notification after a few minutes
     */
    func sendLocalNotificationWithMessageAfterGivenTime(message: String!, playSound: Bool, minutes: Double) {
        
        let startAction = UIMutableUserNotificationAction()
        startAction.identifier = "START_TIMER"
        startAction.title = "START"
        startAction.activationMode = UIUserNotificationActivationMode.Background
        startAction.authenticationRequired = false
        startAction.destructive = false
        
        let snoozeAction = UIMutableUserNotificationAction()
        snoozeAction.identifier = "SNOOZE_TIMER10"
        snoozeAction.title = "IN 10"
        snoozeAction.activationMode = UIUserNotificationActivationMode.Background
        snoozeAction.authenticationRequired = false
        snoozeAction.destructive = false
        
        let snooze30Action = UIMutableUserNotificationAction()
        snooze30Action.identifier = "SNOOZE_TIMER30"
        snooze30Action.title = "IN 30"
        snooze30Action.activationMode = UIUserNotificationActivationMode.Background
        snooze30Action.authenticationRequired = false
        snooze30Action.destructive = false
        
        let stopSnoozeAction = UIMutableUserNotificationAction()
        stopSnoozeAction.identifier = "STOP_SNOOZE"
        stopSnoozeAction.title = "ENABLE DETECTION"
        stopSnoozeAction.activationMode = UIUserNotificationActivationMode.Background
        stopSnoozeAction.authenticationRequired = false
        stopSnoozeAction.destructive = false
        
        
        // Category
        let timerCategory = UIMutableUserNotificationCategory()
        timerCategory.identifier = "TIMER_CATEGORY"
        
        // A. Set actions for the default context
        timerCategory.setActions([stopSnoozeAction,startAction],forContext: UIUserNotificationActionContext.Default)
        
        // B. Set actions for the minimal context
        timerCategory.setActions([stopSnoozeAction,startAction],forContext: UIUserNotificationActionContext.Minimal)
        
        // 3. Notification Registration *****************************************
        
        let types = UIUserNotificationType.Alert
        let settings = UIUserNotificationSettings(forTypes: types, categories: NSSet(object: timerCategory) as? Set<UIUserNotificationCategory>)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertBody = message
        localNotification.category = "TIMER_CATEGORY"
        
        let ScheduledDate = NSDate().dateByAddingTimeInterval(minutes * 60.0)
        localNotification.fireDate = ScheduledDate
        if(playSound) {
            // classic star trek communicator beep
            //	http://www.trekcore.com/audio/
            //
            // note: convert mp3 and wav formats into caf using:
            //	"afconvert -f caff -d LEI16@44100 -c 1 in.wav out.caf"
            // http://stackoverflow.com/a/10388263
            
            localNotification.soundName = "tos_beep.caf";
        }
        
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    /**
     *  Local notification with the ability to stop
     */
    func sendLocalNotificationWithMessageAndButton(message: String!, playSound: Bool) {
        
        let stopAction = UIMutableUserNotificationAction()
        stopAction.identifier = "STOP_TIMER"
        stopAction.title = "STOP"
        stopAction.activationMode = UIUserNotificationActivationMode.Background
        stopAction.authenticationRequired = false
        stopAction.destructive = false
        
        let snoozeAction = UIMutableUserNotificationAction()
        snoozeAction.identifier = "SNOOZE_TIMER10"
        snoozeAction.title = "IN 10"
        snoozeAction.activationMode = UIUserNotificationActivationMode.Background
        snoozeAction.authenticationRequired = false
        snoozeAction.destructive = false
        
        let snooze30Action = UIMutableUserNotificationAction()
        snooze30Action.identifier = "SNOOZE_TIMER30"
        snooze30Action.title = "IN 30"
        snooze30Action.activationMode = UIUserNotificationActivationMode.Background
        snooze30Action.authenticationRequired = false
        snooze30Action.destructive = false
        
        
        // Category
        let timerCategory = UIMutableUserNotificationCategory()
        timerCategory.identifier = "TIMER_CATEGORY"
        
        // A. Set actions for the default context
        timerCategory.setActions([stopAction,snooze30Action],
                                 forContext: UIUserNotificationActionContext.Default)
        
        // B. Set actions for the minimal context
        timerCategory.setActions([stopAction,snooze30Action],
                                 forContext: UIUserNotificationActionContext.Minimal)
        
        
        // 3. Notification Registration *****************************************
        
        let types = UIUserNotificationType.Alert
        let settings = UIUserNotificationSettings(forTypes: types, categories: NSSet(object: timerCategory) as? Set<UIUserNotificationCategory>)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        
        
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertBody = message
        localNotification.category = "TIMER_CATEGORY"
        
        if(playSound) {
            // classic star trek communicator beep
            //	http://www.trekcore.com/audio/
            //
            // note: convert mp3 and wav formats into caf using:
            //	"afconvert -f caff -d LEI16@44100 -c 1 in.wav out.caf"
            // http://stackoverflow.com/a/10388263
            
            localNotification.soundName = "tos_beep.caf";
        }
        
        
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    //MARK: CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager,
                         didRangeBeacons beacons: [CLBeacon],
                                         inRegion region: CLBeaconRegion) {
        
        print("didRangeBeacons");
        if(beacons.count > 0) {
            let nearestBeacon:CLBeacon = beacons[0]
            if(nearestBeacon.proximity == lastProximity ||
                nearestBeacon.proximity == CLProximity.Unknown) {
                return;
            }
            lastProximity = nearestBeacon.proximity;
            
            //               self.sendLocalNotificationWithMessageAndButton("Toggl tracker started", playSound: false)
        }
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        self.locationManager?.requestStateForRegion(region)
    }
    
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        if (state == .Inside && !stateDeterminated && region is CLBeaconRegion){
            stateDeterminated = true
            beaconDetected=true
            print("You entered the region 2 Beaconnaly")
            startNewTask()
        }else if (state == .Inside && !stateDeterminated && region is CLCircularRegion){
            stateDeterminated = true
            geolocationDetected=true
            print("You entered the region 2 Geographicaly")
            startNewTask()
        }
        
    }
    
    func locationManager(manager: CLLocationManager,didEnterRegion region: CLRegion) {
        //            manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        //            manager.startUpdatingLocation()
        let snoozeState = AppPreferences.getSnooze() as! Bool
        if snoozeState == false {
            
            if region is CLBeaconRegion {
                beaconDetected=true
                print("-> You entered in a Beacon Region")
                AnswersTracking.trackEventEnterInBeaconRegion()
                startNewTask()
            }
            if region is CLCircularRegion {
                // handleRegionEvent(region)
                geolocationDetected=true
                print("-> You enter in a geofence Region")
                AnswersTracking.trackEventEnterInGeofenceRegion()
                startNewTask()
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if CLLocationManager.authorizationStatus() == .Denied {
            print("User has denied location services")
            AnswersTracking.trackEventUserDeniedLocationServices()
        }else{
            print("location manager did fail with error: \(error.localizedFailureReason)")
        }
    }
    
    
    func locationManager(manager: CLLocationManager,didExitRegion region: CLRegion) {
        //            manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        //            manager.stopUpdatingLocation()
        let snoozeState = AppPreferences.getSnooze() as! Bool
        if snoozeState == false {
            if region is CLBeaconRegion {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    
                    let taskID = self.beginBackgroundUpdateTask()
                    
                    print("You exited the region")
                    AnswersTracking.trackEventExitedBeaconRegion()
                    self.beaconDetected=false
                    LetoTogglRestClient.sharedInstance.stopCurrentTimeEntry({ () -> Void in
                        self.sendLocalNotificationWithMessage("Toggl Tracker stopped", playSound: false, showActions: true)
                        NSNotificationCenter.defaultCenter().postNotificationName(AppPreferences.NEED_UPDATE_NOTIF, object: nil)
                    }) { (error) -> Void in
                        //if it fails mainly because of internet connection we can try again to stop the task
                        LetoTogglRestClient.sharedInstance.stopCurrentTimeEntry({ () -> Void in
                            self.sendLocalNotificationWithMessage("Toggl Tracker stopped", playSound: false, showActions: true)
                            NSNotificationCenter.defaultCenter().postNotificationName(AppPreferences.NEED_UPDATE_NOTIF, object: nil)
                        }) { (error) -> Void in
                            self.sendLocalNotificationWithMessage("I am not able to stop your time tracker, please check your internet connection", playSound: false, showActions: false)
                        }
                    }
                    self.endBackgroundUpdateTask(taskID)
                })
            }
            if region is CLCircularRegion {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                    
                    let taskID = self.beginBackgroundUpdateTask()
                    
                    print("You exited the region")
                    AnswersTracking.trackEventExitedGeofenceRegion()
                    self.geolocationDetected=false
                    LetoTogglRestClient.sharedInstance.stopCurrentTimeEntry({ () -> Void in
                        self.sendLocalNotificationWithMessage("Toggl Tracker stopped", playSound: false, showActions: true)
                        NSNotificationCenter.defaultCenter().postNotificationName(AppPreferences.NEED_UPDATE_NOTIF, object: nil)
                    }) { (error) -> Void in
                        //if it fails mainly because of internet connection we can try again to stop the task
                        LetoTogglRestClient.sharedInstance.stopCurrentTimeEntry({ () -> Void in
                            self.sendLocalNotificationWithMessage("Toggl Tracker stopped", playSound: false, showActions: true)
                            NSNotificationCenter.defaultCenter().postNotificationName(AppPreferences.NEED_UPDATE_NOTIF, object: nil)
                        }) { (error) -> Void in
                            self.sendLocalNotificationWithMessage("I am not able to stop your time tracker, please check your internet connection", playSound: false, showActions: false)
                        }
                    }
                    self.endBackgroundUpdateTask(taskID)
                })
                
                
            }
        }
    }
    
    //    func handleRegionEvent(region: CLRegion) {
    //        // Show an alert if application is active
    //        if UIApplication.sharedApplication().applicationState == .Active {
    //            if let message = notefromRegionIdentifier(region.identifier) {
    //                if let viewController = window?.rootViewController {
    //                    showSimpleAlertWithTitle(nil, message: message, viewController: viewController)
    //                    print("\(message)")
    //                }
    //            }
    //        } else {
    //            // Otherwise present a local notification
    //            let notification = UILocalNotification()
    //            notification.alertBody = notefromRegionIdentifier(region.identifier)
    //            notification.soundName = "Default";
    //            UIApplication.sharedApplication().presentLocalNotificationNow(notification)
    //        }
    //    }
    //
    //    func notefromRegionIdentifier(identifier: String) -> String? {
    //        if let savedItems = NSUserDefaults.standardUserDefaults().arrayForKey(kSavedItemsKey) {
    //            for savedItem in savedItems {
    //                if let geotification = NSKeyedUnarchiver.unarchiveObjectWithData(savedItem as! NSData) as? Geotification {
    //                    if geotification.identifier == identifier {
    //                        return geotification.note
    //                    }
    //                }
    //            }
    //        }
    //        return nil
    //    }
    
    func locationManager(manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        // if isOfficeLocation {
        if let coordinates = manager.location!.coordinate as CLLocationCoordinate2D?{
            let userCoordinates = CLLocation (latitude: coordinates.latitude, longitude: coordinates.longitude)
            if let currentGeotification = AppPreferences.getGeotification() as Geotification?{
                let officeCoordinates  = CLLocation (latitude: currentGeotification.coordinate.latitude, longitude: currentGeotification.coordinate.longitude)
                let distance = AppUtils.calculateDistanceBetweenTwoLocationsInMeters(userCoordinates, destination: officeCoordinates)
                
                //print("distance = \(distance)")
                
                let info  = ["distance" : distance,
                             "userLocation":userCoordinates,
                             "geofence":currentGeotification]
                
                NSNotificationCenter.defaultCenter().postNotificationName(AppPreferences.DISTANCE_NOTIF, object: self, userInfo:info)
                
            }
            
        }
        //}
    }
    
    func startNewTask(){
        if lastNotfDate == nil || Int(NSDate().timeIntervalSinceDate(lastNotfDate!)) > MIN_SEC_NOTF  {
            self.lastNotfDate = NSDate()
            LetoTogglRestClient.sharedInstance.startLastTimeEntry({ () -> Void in
                self.lastNotfDate = NSDate()
                self.sendLocalNotificationWithMessageAndButton("Toggl tracker started", playSound: false)
                NSNotificationCenter.defaultCenter().postNotificationName(AppPreferences.NEED_UPDATE_NOTIF, object: self)
            }) { (error) -> Void in
                //do nothing
                self.sendLocalNotificationWithMessage("I am not able to start your time tracker, please check your internet connection", playSound: false, showActions: false)
            }
            
        }
    }
    
    func beginBackgroundUpdateTask() -> UIBackgroundTaskIdentifier {
        return UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler({})
    }
    
    func endBackgroundUpdateTask(taskID: UIBackgroundTaskIdentifier) {
        UIApplication.sharedApplication().endBackgroundTask(taskID)
    }
    
    func showSimpleAlertWithTitle(title: String!, message: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
        alert.addAction(action)
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func exitOnRegion (){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            let taskID = self.beginBackgroundUpdateTask()
            
            print("You exited the region")
            LetoTogglRestClient.sharedInstance.stopCurrentTimeEntry({ () -> Void in
                self.sendLocalNotificationWithMessage("Toggl Tracker stopped", playSound: false, showActions: true)
                NSNotificationCenter.defaultCenter().postNotificationName(AppPreferences.NEED_UPDATE_NOTIF, object: nil)
            }) { (error) -> Void in
                //if it fails mainly because of internet connection we can try again to stop the task
                LetoTogglRestClient.sharedInstance.stopCurrentTimeEntry({ () -> Void in
                    self.sendLocalNotificationWithMessage("Toggl Tracker stopped", playSound: false, showActions: true)
                    NSNotificationCenter.defaultCenter().postNotificationName(AppPreferences.NEED_UPDATE_NOTIF, object: nil)
                }) { (error) -> Void in
                    self.sendLocalNotificationWithMessage("I am not able to stop your time tracker, please check your internet connection", playSound: false, showActions: false)
                }
            }
            self.endBackgroundUpdateTask(taskID)
        })
    }
    
    
    func configureNullStateSnooze() {
        if AppPreferences.getSnooze() == nil {
            AppPreferences.setSnooze(false)
        }
    }
    
    func checkPreviousDetectionState(){
        if let state = AppPreferences.getDetectionState() as? Bool {
            if state == true {
                AppPreferences.setDetectionState("beacon")
            }else{
                AppPreferences.setDetectionState("none")
            }
        }
    }
    
    
}
