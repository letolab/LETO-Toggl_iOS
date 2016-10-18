//
//	TimeEntry.swift
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class TimeEntry : NSObject, NSCoding{
    
    var at : String!
    var billable : Bool!
    var descriptionField : String!
    var duration : Int!
    var duronly : Bool!
    var guid : String!
    var id : Int?
    var pid : Int!
    var start : String!
    var stop : String?
    var tags : [String]?
    var uid : Int!
    var wid : Int!
    var projectObj : Project?
    var durationString : NSMutableAttributedString!
    var createdWith : String!

    override init() {
        super.init()
    }
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: NSDictionary){
        at = dictionary["at"] as? String
        billable = dictionary["billable"] as? Bool
        descriptionField = dictionary["description"] as? String
        duration = dictionary["duration"] as? Int
        duronly = dictionary["duronly"] as? Bool
        guid = dictionary["guid"] as? String
        id = dictionary["id"] as? Int
        pid = dictionary["pid"] as? Int
        start = dictionary["start"] as? String
        stop = dictionary["stop"] as? String
        uid = dictionary["uid"] as? Int
        wid = dictionary["wid"] as? Int
        tags = dictionary["tags"] as? [String]
        createdWith = dictionary["created_with"] as? String
        if descriptionField == nil {
            descriptionField = "-"
        }
        projectObj = Project.init(name:"-", color:"15")
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if at != nil{
            dictionary["at"] = at
        }
        if billable != nil{
            dictionary["billable"] = billable
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if duration != nil{
            dictionary["duration"] = duration
        }
        if duronly != nil{
            dictionary["duronly"] = duronly
        }
        if guid != nil{
            dictionary["guid"] = guid
        }
        if id != nil{
            dictionary["id"] = id
        }
        if pid != nil{
            dictionary["pid"] = pid
        }
        if start != nil{
            dictionary["start"] = start
        }
        if stop != nil{
            dictionary["stop"] = stop
        }
        if uid != nil{
            dictionary["uid"] = uid
        }
        if wid != nil{
            dictionary["wid"] = wid
        }
        if tags != nil{
            dictionary["tags"] = tags
        }
        if createdWith != nil{
            dictionary["created_with"] = createdWith
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        at = aDecoder.decodeObjectForKey("at") as? String
        billable = aDecoder.decodeObjectForKey("billable") as? Bool
        descriptionField = aDecoder.decodeObjectForKey("description") as? String
        duration = aDecoder.decodeObjectForKey("duration") as? Int
        duronly = aDecoder.decodeObjectForKey("duronly") as? Bool
        guid = aDecoder.decodeObjectForKey("guid") as? String
        id = aDecoder.decodeObjectForKey("id") as? Int
        pid = aDecoder.decodeObjectForKey("pid") as? Int
        start = aDecoder.decodeObjectForKey("start") as? String
        stop = aDecoder.decodeObjectForKey("stop") as? String
        uid = aDecoder.decodeObjectForKey("uid") as? Int
        wid = aDecoder.decodeObjectForKey("wid") as? Int
        tags = aDecoder.decodeObjectForKey("tags") as? [String]
        createdWith = aDecoder.decodeObjectForKey("created_with") as? String

    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encodeWithCoder(aCoder: NSCoder)
    {
        if at != nil{
            aCoder.encodeObject(at, forKey: "at")
        }
        if billable != nil{
            aCoder.encodeObject(billable, forKey: "billable")
        }
        if descriptionField != nil{
            aCoder.encodeObject(descriptionField, forKey: "description")
        }
        if duration != nil{
            aCoder.encodeObject(duration, forKey: "duration")
        }
        if duronly != nil{
            aCoder.encodeObject(duronly, forKey: "duronly")
        }
        if guid != nil{
            aCoder.encodeObject(guid, forKey: "guid")
        }
        if id != nil{
            aCoder.encodeObject(id, forKey: "id")
        }
        if pid != nil{
            aCoder.encodeObject(pid, forKey: "pid")
        }
        if start != nil{
            aCoder.encodeObject(start, forKey: "start")
        }
        if stop != nil{
            aCoder.encodeObject(stop, forKey: "stop")
        }
        if uid != nil{
            aCoder.encodeObject(uid, forKey: "uid")
        }
        if wid != nil{
            aCoder.encodeObject(wid, forKey: "wid")
        }
        if tags != nil{
            aCoder.encodeObject(wid, forKey: "tags")
        }
        if createdWith != nil{
            aCoder.encodeObject(createdWith, forKey: "created_with")
        }
    }
    
}