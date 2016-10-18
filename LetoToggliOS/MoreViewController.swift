//
//  MoreViewController.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 04/07/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation
import MessageUI

class MoreViewController: BaseTableViewController, MFMailComposeViewControllerDelegate {

    var projects : [Project]!
    var clients : [Client]!
    
    @IBOutlet weak var beaconStatus: UILabel!
    @IBOutlet weak var geofenceStatus: UILabel!
    
    @IBOutlet weak var versionLabel: UILabel!
    
    let headerSectionTitles = ["TIME TRACKER", "SETTINGS", "SUPPORT"]
    
    let EMAIL_ADDRESS = "team@weareleto.com"
    
    @IBOutlet weak var feedbackCell: UITableViewCell!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initUI()
    }
    
    func initUI(){
        beaconStatus.text = "off"
        geofenceStatus.text = "off"
        if let state = AppPreferences.getDetectionState() as! String?{
            if state == DetectionState.OnDetectionBeacon.rawValue {
                beaconStatus.text = "on"
            }else if state == DetectionState.OnDetectionGeofence.rawValue {
                geofenceStatus.text = "on"
            }
        }
        
        let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
        let version = nsObject as! String
        versionLabel.text = "Version " +  version
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goToMonthView") {
            // pass data to next view
            let destVC = segue.destinationViewController as! MonthViewController
            destVC.projects=projects
            destVC.clients=clients
            AnswersTracking.trackEventCheckLast30Days()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView.cellForRowAtIndexPath(indexPath) == feedbackCell {
            sendEmail()
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createHeaderWithTitle(headerSectionTitles[section])
    }
    
    @IBAction func logoutPressed(sender: AnyObject) {
        AppPreferences.setApiToken("")
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let rootViewController = appDelegate.window!.rootViewController as! UINavigationController
        rootViewController.popToRootViewControllerAnimated(true)
        AnswersTracking.trackEventSignOut()
        UIApplication.sharedApplication().shortcutItems = []
    }
    
    func sendEmail () {
        let email = MFMailComposeViewController()
        email.mailComposeDelegate = self;
        email.setSubject("LETO Toggl - " + versionLabel.text!)
        email.setToRecipients([EMAIL_ADDRESS])
        presentViewController(email, animated: true, completion: nil)

    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
