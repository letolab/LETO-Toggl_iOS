//
//  GeofenceSettingsViewController.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 04/07/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation

class GeofenceSettingsViewController: BaseTableViewController, UITextFieldDelegate {

    @IBOutlet weak var detectionSwitch: UISwitch!
    @IBOutlet weak var addressTF: UITextField!
    
    private var embeddedViewController: GeolocationViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI(){
        if let state = AppPreferences.getDetectionState() as! String?{
            if state == DetectionState.OnDetectionGeofence.rawValue {
                detectionSwitch.setOn(true, animated: false)
            }else{
                detectionSwitch.setOn(false, animated: false)
            }
        }
        
//        if let beaconUuid = AppPreferences.getBeaconUuid(){
//            beaconUUID = beaconUuid as! String
//        }else{
//            beaconUUID = ""
//            AppPreferences.setBeaconUuid(self.beaconUUID)
//        }
//        self.beaconUUIDTF.text=self.beaconUUID
        
        detectionSwitch.addTarget(self, action: #selector(GeofenceSettingsViewController.switchChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        embeddedViewController.addGeofenceUsingAddress(textField.text!)
        return false
    }
    
    func switchChanged(mySwitch: UISwitch){
        if mySwitch.on {
//            if self.beaconUUIDTF.text=="" {
//                self.presentViewController(alertBeacon, animated: true, completion:nil)
//            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? GeolocationViewController
            where segue.identifier == "EmbedSegue" {
            self.embeddedViewController = vc
            self.embeddedViewController.parentAddressTF = addressTF
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return createHeaderWithTitle("GEOFENCE SETTINGS")
        }
        return createHeaderWithTitle("")
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if  detectionSwitch.on  {
            // TURN GEOFENCE DETECTION ON
            AppPreferences.setDetectionState(DetectionState.OnDetectionGeofence.rawValue)
            AppPreferences.setGeotification(self.embeddedViewController.currentGeotification!)
            AnswersTracking.trackEventGeofenceDetectionActivation()
            self.embeddedViewController.startMonitoringGeotification(self.embeddedViewController.currentGeotification!)
        }else{
            // TURN GEOFENCE DETECTION OFF
            if let state = AppPreferences.getDetectionState() as! String?{
                if state == DetectionState.OnDetectionGeofence.rawValue {
                    AnswersTracking.trackEventGeofenceDetectionDeactivation()
                    AppPreferences.setDetectionState(DetectionState.OnNonDetection.rawValue)
                    self.embeddedViewController.stopMonitoringGeotification(self.embeddedViewController.currentGeotification!)
                }
            }
        }
    }
}
