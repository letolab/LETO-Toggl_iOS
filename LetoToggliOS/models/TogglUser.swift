//
//	TooglUser.swift
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class TogglUser : NSObject, NSCoding{
    
    var data : UserData!
    var since : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: NSDictionary){
        if let dataData = dictionary["data"] as? NSDictionary{
            data = UserData(fromDictionary: dataData)
        }
        since = dictionary["since"] as? Int
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if data != nil{
            dictionary["data"] = data.toDictionary()
        }
        if since != nil{
            dictionary["since"] = since
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        data = aDecoder.decodeObjectForKey("data") as? UserData
        since = aDecoder.decodeObjectForKey("since") as? Int
        
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
        if since != nil{
            aCoder.encodeObject(since, forKey: "since")
        }
        
    }
    
}