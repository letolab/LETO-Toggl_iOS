//
//  BeaconSettingsViewController.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 04/07/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation
import NBMaterialDialogIOS

class BeaconSettingsViewController: BaseTableViewController {
    
    var alertTextField : UITextField!
    var alertBeacon : UIAlertController!
    var beaconUUID = ""
    
    @IBOutlet weak var detectionSwitch: UISwitch!
    @IBOutlet weak var beaconUUIDTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    func initUI(){
        if let state = AppPreferences.getDetectionState() as! String?{
            if state == DetectionState.OnDetectionBeacon.rawValue {
                detectionSwitch.setOn(true, animated: false)
            }else{
                detectionSwitch.setOn(false, animated: false)
            }
        }
        
        if let beaconUuid = AppPreferences.getBeaconUuid(){
            beaconUUID = beaconUuid as! String
        }else{
            beaconUUID = ""
            AppPreferences.setBeaconUuid(self.beaconUUID)
        }
        self.beaconUUIDTF.text=self.beaconUUID
        
        detectionSwitch.addTarget(self, action: #selector(BeaconSettingsViewController.switchChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        configureAlertBeacon()
    }
    
    
    func configureAlertBeacon(){
        alertBeacon = UIAlertController(title: NSLocalizedString("localized_beacon_uuid_title", comment: ""), message: NSLocalizedString("localized_beacon_uuid_message", comment: ""), preferredStyle:
            UIAlertControllerStyle.Alert)
        alertBeacon.addTextFieldWithConfigurationHandler(configurationTextField)
        alertBeacon.addAction(UIAlertAction(title: NSLocalizedString("localized_cancel", comment: ""), style: UIAlertActionStyle.Default, handler:{ (UIAlertAction) in
            self.detectionSwitch.setOn(false, animated: true)
            self.beaconUUIDTF.text=""
        }))
        alertBeacon.addAction(UIAlertAction(title: NSLocalizedString("localized_ok", comment: ""), style: UIAlertActionStyle.Default, handler:{ (UIAlertAction) in
            print(self.alertTextField.text)
            if(self.alertTextField.text!.characters.count == 36){
                self.detectionSwitch.setOn(true, animated: true)
                self.beaconUUID=self.alertTextField.text!
                self.beaconUUIDTF.text=self.beaconUUID
            }else{
                self.detectionSwitch.setOn(false, animated: true)
                self.beaconUUIDTF.text=""
                NBMaterialSnackbar.showWithText(self.tableView.superview!, text: NSLocalizedString("localized_uuid_lengh", comment: ""), duration: NBLunchDuration.LONG)
            }
        }))
    }

    func configurationTextField(textField: UITextField!){
        if let aTextField = textField {
            alertTextField=aTextField
            alertTextField.text=beaconUUID
        }
    }
    
    func switchChanged(mySwitch: UISwitch){
        if mySwitch.on {
            if self.beaconUUIDTF.text=="" {
                self.presentViewController(alertBeacon, animated: true, completion:nil)
            }
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return createHeaderWithTitle("IBEACON SETTINGS")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row==1 {
            self.presentViewController(alertBeacon, animated: true, completion:nil)
            self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
            return
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate

        if  detectionSwitch.on  {
            // TURN BEACON DETECTION ON
            AppPreferences.setDetectionState(DetectionState.OnDetectionBeacon.rawValue)
            AppPreferences.setBeaconUuid(self.beaconUUID)
            AnswersTracking.trackEventBeaconDetectionActivation()
            if appDelegate.isBeaconListenerActive {
                appDelegate.stopBeaconListener()
            }
            appDelegate.beaconDetected=false
            appDelegate.setupBeaconListener()
        }else{
            // TURN BEACON DETECTION OFF
            if let state = AppPreferences.getDetectionState() as! String?{
                if state == DetectionState.OnDetectionBeacon.rawValue {
                    AppPreferences.setDetectionState(DetectionState.OnNonDetection.rawValue)
                    if appDelegate.isBeaconListenerActive {
                        appDelegate.stopBeaconListener()
                    }
                }
            }
        }
    }

}
