//
//  AppPreferences.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 07/03/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation
import CoreLocation

class AppPreferences{

    //NOTIFICATIONS KEYS
    static let NEED_UPDATE_NOTIF = "need_update"
    static let DISTANCE_NOTIF = "distance"
    
    // USER DEFAULTS
    static let defaults = NSUserDefaults.standardUserDefaults()
    
    static let API_TOKEN_KEY = "api_token_key"
    static let DETECTION_STATE = "detection_state"
    static let BEACON_UUID = "beacon_uuid"
    static let GEOTIFICATION = "Geotification"
    static let SNOOZE = "Snooze"
    static let WORKSPACE_ID = "wid"

       // GETTERS
    static func getApiToken()->AnyObject!{
        return defaults.objectForKey(API_TOKEN_KEY)
    }
    
    static func getDetectionState()->AnyObject?{
        return defaults.objectForKey(DETECTION_STATE)
    }
    
    static func getBeaconUuid()->AnyObject!{
        return defaults.objectForKey(BEACON_UUID)
    }
    
    static func getGeotification()->Geotification?{
        if let geotification = defaults.objectForKey(GEOTIFICATION) as! NSData?{
            return NSKeyedUnarchiver.unarchiveObjectWithData(geotification) as? Geotification
        }
        return nil
    }
    
    static func getSnooze()->AnyObject?{
        return defaults.objectForKey(SNOOZE)
    }
    
    static func getWorksapceID()->AnyObject?{
        return defaults.objectForKey(WORKSPACE_ID)
    }
    
    //SETTERS
    static func setApiToken(value:String){
        defaults.setObject(value, forKey: API_TOKEN_KEY)
        defaults.synchronize()
        //print("/(API_TOKEN_KEY): \(value)")
    }
    
    static func setDetectionState(value:String){
        defaults.setObject(value, forKey:DETECTION_STATE)
        defaults.synchronize()
        //print("/(DETECTION_STATE): \(value)")
    }
    
    static func setBeaconUuid(value:String){
        defaults.setObject(value, forKey: BEACON_UUID)
        defaults.synchronize()
        //print("/(BEACON_UUID): \(value)")
    }
    
    static func setGeotification(geotification:Geotification){
        defaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(geotification), forKey: GEOTIFICATION)
        defaults.synchronize()
        //print("/(GEOTIFICATION): \(geotification.title)")
    }
    
    static func setSnooze(value:Bool){
        defaults.setObject(value, forKey:SNOOZE)
        defaults.synchronize()
        //print("/(SNOOZE): \(value)")
    }
    
    static func setWorksapceID(value:Int){
        defaults.setObject(value, forKey:WORKSPACE_ID)
        defaults.synchronize()
        //print("/(SNOOZE): \(value)")
    }

}

//Enum
enum DetectionState: String {
    case OnDetectionBeacon = "beacon"
    case OnDetectionGeofence = "geofence"
    case OnNonDetection = "none"
}


