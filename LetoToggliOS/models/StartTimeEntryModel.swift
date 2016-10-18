//
//  StartTimeEntryModel.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 15/03/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation


class StartTimeEntryModel : NSObject, NSCoding{
    
    var data : TimeEntry?
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: NSDictionary){
        if let dataData = dictionary["time_entry"] as? NSDictionary{
            data = TimeEntry(fromDictionary: dataData)
        }
    }
    
    init(fromEntry entry:TimeEntry){
        data=entry
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if data != nil{
            dictionary["time_entry"] = data!.toDictionary()
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        data = aDecoder.decodeObjectForKey("time_entry") as? TimeEntry
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encodeWithCoder(aCoder: NSCoder)
    {
        if data != nil{
            aCoder.encodeObject(data, forKey: "time_entry")
        }
        
    }
    
}