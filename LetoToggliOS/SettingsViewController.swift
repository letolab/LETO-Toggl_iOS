//
//  SettingsViewController.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 14/03/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation
import NBMaterialDialogIOS

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var beaconImage: UIImageView!
    @IBOutlet weak var geofenceImage: UIImageView!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var beaconUUIDLabel: UILabel!
    
    var alertTextField : UITextField!
    var isBeaconActive = false
    var isGeofenceActive = false
    var alertBeacon : UIAlertController!
    var alertGeofence : UIAlertController!
    var alertNoGeofence : UIAlertController!
    var beaconUUID = ""
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setupStateLabel()
        AnswersTracking.trackEventScreen("SettingsViewController Will Appear")
    }
    
    func initUI(){
        if let state = AppPreferences.getDetectionState() as! String?{
            switch state{
            case DetectionState.OnDetectionBeacon.rawValue:
                  isBeaconActive=true
                break
               
            case DetectionState.OnDetectionGeofence.rawValue:
                  isGeofenceActive=true
                break
            default:
                
                break
            }
        }
 
        if let beaconUuid = AppPreferences.getBeaconUuid(){
            beaconUUID = beaconUuid as! String
        }else{
            beaconUUID = ""
            AppPreferences.setBeaconUuid(self.beaconUUID)
        }
        
        configureAlertBeacon()
        setupState()
    }
    
    func configureAlertBeacon(){
        alertBeacon = UIAlertController(title: NSLocalizedString("localized_beacon_uuid_title", comment: ""), message: NSLocalizedString("localized_beacon_uuid_message", comment: ""), preferredStyle:
            UIAlertControllerStyle.Alert)
        alertBeacon.addTextFieldWithConfigurationHandler(configurationTextField)
        alertBeacon.addAction(UIAlertAction(title: NSLocalizedString("localized_cancel", comment: ""), style: UIAlertActionStyle.Default, handler:{ (UIAlertAction) in
            
        }))
        alertBeacon.addAction(UIAlertAction(title: NSLocalizedString("localized_ok", comment: ""), style: UIAlertActionStyle.Default, handler:{ (UIAlertAction) in
            print(self.alertTextField.text)
            if(self.alertTextField.text!.characters.count == 36){
                self.isBeaconActive=true
                AnswersTracking.trackEventTryBeaconActivation()
                self.beaconUUID=self.alertTextField.text!
                self.setupState()
            }else{
                NBMaterialSnackbar.showWithText(self.view, text: NSLocalizedString("localized_uuid_lengh", comment: ""), duration: NBLunchDuration.LONG)
            }
            
        }))
    }
    
    func setupState(){
        
        if isBeaconActive {
            beaconImage.image=UIImage(named: "beacon_enabled")
            beaconUUIDLabel.text=beaconUUID
        }else{
            beaconImage.image=UIImage(named: "beacon_disabled")
            messageLabel.text=String(format: NSLocalizedString("localized_settings_message_format", comment: ""), "enable")
            beaconUUIDLabel.text=""
        }
        
        if isGeofenceActive {
            geofenceImage.image=UIImage(named: "geofence_enabled")
            messageLabel.text=String(format: NSLocalizedString("localized_settings_message_format", comment: ""), "disable")
        }else{
            geofenceImage.image=UIImage(named: "geofence_disabled")
            messageLabel.text=String(format: NSLocalizedString("localized_settings_message_format", comment: ""), "enable")
        }
        
        
    }
    
    func setupStateLabel(){
        stateLabel.textColor=MainPalette.mediumGreyTextColor()
        stateLabel.text=NSLocalizedString("localized_all_disabled", comment: "")

        if appDelegate.isBeaconListenerActive && !isGeofenceActive {
            stateLabel.textColor=MainPalette.accentColor()
            stateLabel.text=NSLocalizedString("localized_beacon_enabled", comment: "")
        }
        
        if appDelegate.isGeofenceListenerActive && !isBeaconActive  {
            stateLabel.textColor=MainPalette.accentColor()
            stateLabel.text=NSLocalizedString("localized_geofence_enabled", comment: "")
        }
    
    }
    
    @IBAction func beaconImagePressed(sender: UITapGestureRecognizer) {
        stateLabel.text = ""
        if !isGeofenceActive {
            if isBeaconActive {
                AnswersTracking.trackEventTryBeaconDeactivation()
                isBeaconActive=false
                setupState()
            }else{
                setupState()
                self.presentViewController(alertBeacon, animated: true, completion:nil)
            }
        }else{
            //print("Deactivate Geofence Detection First")
             AnswersTracking.trackEventUserNeedsToDeactivateGeofenceDetectionFirst()
        }
        setupStateLabel()
    }
    
    @IBAction func geofenceImagePressed(sender: UITapGestureRecognizer) {
       stateLabel.text = ""
        if !isBeaconActive {
         if isGeofenceActive {
            AnswersTracking.trackEventTryGeofenceDeactivation()
            isGeofenceActive=false
            setupState()
         }else{
            self.isGeofenceActive=true
            AnswersTracking.trackEventTryGeofenceActivation()
            setupState()
         }
        }else{
            //print("Deactivate Beacon Detection first")
            AnswersTracking.trackEventUserNeedsToDeactivateBeaconDetectionFirst()
        }
       setupStateLabel()
    }
    
    func configurationTextField(textField: UITextField!){
        if let aTextField = textField {
            alertTextField=aTextField
            alertTextField.text=beaconUUID
        }
    }

    
    @IBAction func seeGeolocation(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let geolocationViewController = storyboard.instantiateViewControllerWithIdentifier("GeolocationViewController") as! GeolocationViewController
        self.navigationController!.pushViewController(geolocationViewController, animated: true)
    }
    
    @IBAction func savePressed(sender: UIButton) {
        if self.isBeaconActive {
            AppPreferences.setDetectionState("beacon")
            AppPreferences.setBeaconUuid(self.beaconUUID)
            AnswersTracking.trackEventBeaconDetectionActivation()
            appDelegate.beaconDetected=false
            if isBeaconActive{
                appDelegate.setupBeaconListener()
            }
            self.navigationController?.popViewControllerAnimated(true)
        }else if self.isGeofenceActive{
           AppPreferences.setDetectionState("geofence")
            AnswersTracking.trackEventGeofenceDetectionActivation()
            appDelegate.geolocationDetected=false
           
                if ((AppPreferences.getGeotification() as Geotification?) == nil){
                    
                    alertNoGeofence = UIAlertController(title: "Warning", message: "There is no geofence configured", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alertNoGeofence.addAction(UIAlertAction(title: "Set geofence", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction) in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let geolocationViewController = storyboard.instantiateViewControllerWithIdentifier("GeolocationViewController") as! GeolocationViewController
                        self.navigationController!.pushViewController(geolocationViewController, animated: true)
                    }))
                     self.presentViewController(alertNoGeofence, animated: true, completion:nil)
                }else{
                    self.appDelegate.setupGeotificationListener()
                    alertGeofence = UIAlertController(title: "Warning", message: "There is already a geofence configured, do you wish to edit it? ", preferredStyle: UIAlertControllerStyle.Alert)
                        
                    alertGeofence.addAction(UIAlertAction(title: "Continue", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction) in
                        
                        
                    }))
                    alertGeofence.addAction(UIAlertAction(title: "Edit geofence", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction) in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let geolocationViewController = storyboard.instantiateViewControllerWithIdentifier("GeolocationViewController") as! GeolocationViewController
                        self.navigationController!.pushViewController(geolocationViewController, animated: true)
                        
                        
                    }))
                    self.presentViewController(alertGeofence, animated: true, completion:nil)
                    }
            
        }else {
          AppPreferences.setDetectionState("none")
            AnswersTracking.trackEventNoneDetectionState()
            if appDelegate.isBeaconListenerActive {
                appDelegate.stopBeaconListener()
            }
            if appDelegate.isGeofenceListenerActive {
                appDelegate.stopGeotificationListener()
            }
        }
       
        setupState()
        setupStateLabel()
    }
}