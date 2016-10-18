//
//  TimeEntryModel.swift
//  LetoToggliOS
//
//  Created by Lorenzo Greco on 15/03/16.
//  Copyright © 2016 Leto. All rights reserved.
//

import Foundation


class TimeEntryModel : NSObject, NSCoding{
    
    var data : TimeEntry?
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: NSDictionary){
        if let dataData = dictionary["data"] as? NSDictionary{
            data = TimeEntry(fromDictionary: dataData)
        }
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if data != nil{
            dictionary["data"] = data!.toDictionary()
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        data = aDecoder.decodeObjectForKey("data") as? TimeEntry
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encodeWithCoder(aCoder: NSCoder)
    {
        if data != nil{
            aCoder.encodeObject(data, forKey: "data")
        }
        
    }
    
}