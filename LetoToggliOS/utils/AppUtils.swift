//
//  AppUtils.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 09/03/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation
import CoreLocation

class AppUtils{
    static let colors : [String] = ["#4dc3ff","#bc85e6","#df7baa","#f68d38","#b27636","#8ab734","#14a88e","#268bb5","#6668b4","#a4506c","#67412c","#3c6526","#094558","#bc2d07","#999999","#AEAEAE"]
    static let HEADER_HEIGHT : CGFloat = 50

    
    static func createCompleteEntriesModel (timeEntries : [TimeEntry], projects : [Project], clients : [Client]) -> [TimeEntry] {
        for var entry : TimeEntry in timeEntries{
            entry = completeTimeEntry(entry, projects: projects, clients: clients)
        }
        return timeEntries
    }
    
    static func completeTimeEntry (timeEntry : TimeEntry, projects : [Project], clients : [Client]) -> TimeEntry {
        // Set Project
        for project:Project in projects{
            if timeEntry.pid != nil && project.id == timeEntry.pid{
                timeEntry.projectObj = project
                break
            }
        }
        
        // Set Client
        for client:Client in clients{
        if let project = timeEntry.projectObj{
            if client.id == project.cid {
                timeEntry.projectObj?.clientObj = client
                break
            }
        }
        
        }
            
       return timeEntry
    }
    
    static func getDurationString (let initialDuration:Int) -> String{
        var duration = initialDuration;
        if duration<0 {
            let nowDouble = NSDate().timeIntervalSince1970
            duration = Int(nowDouble) + duration
        }
        let hours : Int = duration/3600
        var remainder : Int = duration - hours * 3600
        let mins : Int = remainder/60
        remainder = remainder - mins * 60
        let secs : Int = remainder
        
        return "\(hours)"+":"+String(format: "%02d", mins)+":"+String(format: "%02d", secs)
    }
    
    static func setDurationLabel (let initialDuration:Int, label:UILabel) {
        let durationString = getDurationString(initialDuration)
        
        var boldCount = 4
        if durationString.characters.count > 7 {
            boldCount=5
        }
        
        var myMutableString = NSMutableAttributedString()
        myMutableString = NSMutableAttributedString(
            string: durationString,
            attributes: [NSFontAttributeName:UIFont.systemFontOfSize(label.font.pointSize, weight: UIFontWeightRegular)])
        myMutableString.addAttribute(NSFontAttributeName,
                                     value: UIFont.systemFontOfSize(label.font.pointSize, weight: UIFontWeightBlack),
                                     range: NSRange(
                                        location:0,
                                        length:boldCount))
        label.attributedText=myMutableString
    }
    
    static func getColorFromIndex (index:Int) -> UIColor {
        return colorWithHexString(colors[index])
    }
    
    // Creates a UIColor from a Hex string.
    static func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
    static func setupDescriptionLabel(label:UILabel, timeEntry:TimeEntry){
        
      
        var text = ""
        if let projectName = timeEntry.projectObj?.name {
            text = text + projectName        }
                
        var color = UIColor .clearColor()
        
        if let projectColor = timeEntry.projectObj?.color{
            let colorIndex:Int = Int(projectColor)!
            color = getColorFromIndex(colorIndex)
        }
        
        let textColor = UIColor.whiteColor()
    

        label.textColor=textColor
        label.backgroundColor=color
        label.text = text
    }
    
    static func ISOStringFromDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        
        return dateFormatter.stringFromDate(date).stringByAppendingString("Z")
    }
    
    static func dateFromISOString(string: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeZone = NSTimeZone.localTimeZone()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        
        return dateFormatter.dateFromString(string)!
    }
    
    static func dateStringFromISOString(string: String) -> String {
        let date = dateFromISOString(string)
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM yyyy"
        return dateFormatter.stringFromDate(date).uppercaseString
    }
    
    static func calculateDistanceBetweenTwoLocationsInMeters(source:CLLocation,destination:CLLocation) -> Double{
        let distanceMeters = source.distanceFromLocation(destination)
        return  distanceMeters.roundedTwoDigit
    }
    
    static func calculateDistanceBetweenTwoLocationsInKm(source:CLLocation,destination:CLLocation) -> Double{
        let distanceMeters = source.distanceFromLocation(destination)
        let distanceKm = distanceMeters / 1000
        
        return  distanceKm.roundedTwoDigit
    }
    
    
}