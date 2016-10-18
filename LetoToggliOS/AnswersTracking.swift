//
//  AnswersTracking.swift
//  LetoToggliOS
//
//  Created by Ismael Gobernado Alonso on 2/6/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation
import Crashlytics


class AnswersTracking {
    
    static let tracesTracking = true
    
    //MARK: - Screen Events
    
    static func trackEventScreen(screenName :String){
        Answers.logCustomEventWithName("Screen \(screenName)",customAttributes: [:])
        if tracesTracking {
            print("TrackEvent - Screen \(screenName)")
        }
    }
    
    //MARK: - Login & SignOut Events
    
    static func trackEventLoginSuccess() {
        Answers.logLoginWithMethod("Login success",
                                   success: true,
                                   customAttributes: [:])
        if tracesTracking {
            print("TrackEvent - Login success")
        }
    }
    
    static func trackEventLoginFailure(error:String?) {
        if error != nil {
            Answers.logLoginWithMethod("Login failure",
                                       success: false,
                                       customAttributes:["error": error!])
            if tracesTracking {
                print("TrackEvent - Login failure with error: \(error)")
            }
        }else{
            Answers.logLoginWithMethod("Login failure",
                                       success: false,
                                       customAttributes:[:])
            if tracesTracking {
                print("TrackEvent - Login failure")
            }
        }
        
    }
    
    static func trackEventSignOut() {
        Answers.logCustomEventWithName("SignOut",customAttributes: [:])
        if tracesTracking {
            print("TrackEvent - SignOut")
        }
    }
    
    // MARK: - Start Entry Events
    
    static func trackEventStartEntrySuccess(timeEntry: TimeEntry) {
        Answers.logCustomEventWithName("Start entry succesfull",
                                       customAttributes: ["description": timeEntry.descriptionField])
        if tracesTracking {
            print("TrackEvent - Start entry succesfull with entry:\(timeEntry.descriptionField)")
        }
    }
    
    static func trackEventStartEntryFailure(timeEntry: TimeEntry,error: String?) {
        
        if error != nil {
            Answers.logCustomEventWithName("Start entry failure",
                                           customAttributes:["description": timeEntry.descriptionField,
                                            "error": error!])
            if tracesTracking {
                print("TrackEvent - Start entry failure with entry:\(timeEntry.descriptionField) and error: \(error)")
            }
        }else{
            Answers.logCustomEventWithName("Start entry Failure",
                                           customAttributes:["description": timeEntry.descriptionField])
            if tracesTracking {
                print("TrackEvent - Start entry failure \(timeEntry.descriptionField)")
            }
        }
        
    }
    
    // MARK: - Start Last Entry Events
    
    static func trackEventStartLastEntrySuccess(timeEntry: TimeEntry) {
        Answers.logCustomEventWithName("Start last entry succesfull",
                                       customAttributes: ["description": timeEntry.descriptionField])
        if tracesTracking {
            print("TrackEvent - Start last entry succesfull with entry:\(timeEntry.descriptionField)")
        }
    }
    
    static func trackEventStartLastEntryFailure(timeEntry: TimeEntry,error: String?) {
        
        if error != nil {
            Answers.logCustomEventWithName("Start last entry failure",
                                           customAttributes:["description": timeEntry.descriptionField,
                                            "error": error!])
            if tracesTracking {
                print("TrackEvent - Start last entry failure with entry:\(timeEntry.descriptionField) and error: \(error)")
            }
        }else{
            Answers.logCustomEventWithName("Start last entry Failure",
                                           customAttributes:["description": timeEntry.descriptionField])
            if tracesTracking {
                print("TrackEvent - Start last entry failure \(timeEntry.descriptionField)")
            }
        }
        
    }
    
    // MARK: - Stop Entry Events
    
    static func trackEventStopEntrySuccess(timeEntry: TimeEntry) {
        Answers.logCustomEventWithName("Stop entry Sucessfull",
                                       customAttributes: ["description": timeEntry.descriptionField])
        if tracesTracking {
            print("TrackEvent - Stop entry succesfull with entry:\(timeEntry.descriptionField)")
        }
        
    }
    
    static func trackEventStopEntryFailure(timeEntry: TimeEntry,error: String?) {
        
        if error != nil {
            Answers.logCustomEventWithName("Failure stop entry",
                                           customAttributes:["description": timeEntry.descriptionField,
                                            "error": error!])
            if tracesTracking {
                print("TrackEvent - Stop entry failure with entry:\(timeEntry.descriptionField) and error: \(error)")
            }

        }else{
            Answers.logCustomEventWithName("Failure stop entry",
                                           customAttributes:["description": timeEntry.descriptionField])
            if tracesTracking {
                print("TrackEvent - Stop entry failure with entry:\(timeEntry.descriptionField)")
            }
        }
        
    }
    
    // MARK: - Stop Current Entry Events
    
    static func trackEventStopCurrentEntrySuccess(timeEntry: TimeEntry) {
        Answers.logCustomEventWithName("Stop current entry Sucessfull",
                                       customAttributes: ["description": timeEntry.descriptionField])
        if tracesTracking {
            print("TrackEvent - Stop current entry succesfull with entry:\(timeEntry.descriptionField)")
        }
        
    }
    
    static func trackEventStopCurrentEntryFailure(timeEntry: TimeEntry,error: String?) {
        
        if error != nil {
            Answers.logCustomEventWithName("Stop current entry Failure ",
                                           customAttributes:["description": timeEntry.descriptionField,
                                            "error": error!])
            if tracesTracking {
                print("TrackEvent - Stop current entry failure with entry:\(timeEntry.descriptionField) and error: \(error)")
            }
            
        }else{
            Answers.logCustomEventWithName("Stop current entry Failure",
                                           customAttributes:["description": timeEntry.descriptionField])
            if tracesTracking {
                print("TrackEvent - Stop current entry failure with entry:\(timeEntry.descriptionField)")
            }
        }
        
    }

    // MARK: - Check Last 30 Days
    
    static func trackEventCheckLast30Days() {
        Answers.logCustomEventWithName("CheckLast30Days",customAttributes: [:])
        if tracesTracking {
            print("TrackEvent - CheckLast30Days")
        }
    }
    
    // MARK: - Geofence
    
    static func trackEventTryGeofenceDeactivation(){
        Answers.logCustomEventWithName("Try Geofence Deactivation",customAttributes: [:])
        if tracesTracking {
            print("TrackEvent - Try Geofence Deactivation")
        }
    }
    
    static func trackEventTryGeofenceActivation(){
         Answers.logCustomEventWithName("Try Geofence Activation",customAttributes: [:])
         if tracesTracking {
            print("TrackEvent - Try Geofence Activation")
         }
    }
    
    static func trackEventGeofenceDetectionActivation(){
        Answers.logCustomEventWithName("Geofence Detection Activation",customAttributes: [:])
        if tracesTracking {
            print("TrackEvent - Geofence Detection Activation")
        }
    }
    
    static func trackEventGeofenceDetectionDeactivation(){
        Answers.logCustomEventWithName("Geofence Detection Deactivation",customAttributes: [:])
        if tracesTracking {
            print("TrackEvent - Geofence Detection Deactivation")
        }
    }
    
    // MARK: - Beacon
    
    static func trackEventTryBeaconDeactivation(){
        Answers.logCustomEventWithName("Try Beacon Deactivation",customAttributes: [:])
        if tracesTracking {
            print("TrackEvent - Try Beacon Deactivation")
        }
    }
    
    static func trackEventTryBeaconActivation(){
        Answers.logCustomEventWithName("Try Beacon Activation",customAttributes: [:])
        if tracesTracking {
            print("TrackEvent - Try Beacon Activation")
        }
    }

    static func trackEventBeaconDetectionActivation(){
        Answers.logCustomEventWithName("Beacon Detection Activation",customAttributes: [:])
        if tracesTracking {
            print("TrackEvent - Beacon Detection Activation")
        }
    }
    
    static func trackEventBeaconDetectionDeactivation(){
        Answers.logCustomEventWithName("Beacon Detection Deactivation",customAttributes: [:])
        if tracesTracking {
            print("TrackEvent - Beacon Detection Deactivation")
        }
    }
    
    // MARK: - Regions
    
    static func trackEventEnterInBeaconRegion(){
        Answers.logCustomEventWithName(" You entered in a Beacon region",customAttributes: [:])
        if tracesTracking {
            print("TrackEvent - You entered in a Beacon region")
        }
    }
    
    static func trackEventEnterInGeofenceRegion(){
        Answers.logCustomEventWithName(" You entered in a Geofence region",customAttributes: [:])
        if tracesTracking {
            print("TrackEvent - You entered in a Geofence region")
        }
    }
    
    static func trackEventExitedBeaconRegion(){
        Answers.logCustomEventWithName("You have left the beacon region",customAttributes: [:])
        if tracesTracking {
            print("TrackEvent - You have left the beacon region")
        }
    }
    
    static func trackEventExitedGeofenceRegion(){
        Answers.logCustomEventWithName("You have left the geofence region",customAttributes: [:])
        if tracesTracking {
            print("TrackEvent - You have left the geofence region")
        }
    }
    
    // MARK: - Detection state
    
    static func trackEventNoneDetectionState(){
        Answers.logCustomEventWithName("Detection state set to none",customAttributes: [:])
        if tracesTracking {
            print("TrackEvent - Detection state set to none")
        }
    }
    
    // MARK: - Location Services
    
    static func trackEventUserDeniedLocationServices(){
        Answers.logCustomEventWithName("User Denied Location Services",customAttributes: [:])
        if tracesTracking {
            print("TrackEvent - User Denied Location Services")
        }
    }

    // MARK: - User Misunderstanding UI
    
    static func trackEventUserNeedsToDeactivateGeofenceDetectionFirst(){
        Answers.logCustomEventWithName("Deactivate Geofence Detection First",customAttributes: [:])
        if tracesTracking {
            print("TrackEvent - Deactivate Geofence Detection First")
        }
    }
    
    static func trackEventUserNeedsToDeactivateBeaconDetectionFirst(){
        Answers.logCustomEventWithName("Deactivate Beacon Detection First",customAttributes: [:])
        if tracesTracking {
            print("TrackEvent - Deactivate Beacon Detection First")
        }
    }
    
    
    
    // MARK: - Special Tracking for Know errors
    
    //
    static func trackEventResponseDataNil(data:NSData?, nameMethod:String){
        Answers.logCustomEventWithName("Response.data Empty ",customAttributes: [:])
        if tracesTracking {
            print("TrackEvent - Detection state set to none")
        }
    }
    
    
    

}