//
//	Project.swift
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Project : NSObject, NSCoding{
    
    var active : Bool!
    var actualHours : Int!
    var at : String!
    var autoEstimates : Bool!
    var billable : Bool!
    var cid : Int?
    var color : String!
    var createdAt : String!
    var id : Int!
    var isPrivate : Bool!
    var name : String?
    var template : Bool!
    var wid : Int!
    var clientObj : Client!
    
    init(name:String, color:String) {
        super.init()
        self.name=name
        self.color=color
    }
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: NSDictionary){
        active = dictionary["active"] as? Bool
        actualHours = dictionary["actual_hours"] as? Int
        at = dictionary["at"] as? String
        autoEstimates = dictionary["auto_estimates"] as? Bool
        billable = dictionary["billable"] as? Bool
        cid = dictionary["cid"] as? Int
        color = dictionary["color"] as? String
        createdAt = dictionary["created_at"] as? String
        id = dictionary["id"] as? Int
        isPrivate = dictionary["is_private"] as? Bool
        name = dictionary["name"] as? String
        template = dictionary["template"] as? Bool
        wid = dictionary["wid"] as? Int
        clientObj = Client.init(name:"-")
        if cid == nil {
            cid = -1
        }
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if active != nil{
            dictionary["active"] = active
        }
        if actualHours != nil{
            dictionary["actual_hours"] = actualHours
        }
        if at != nil{
            dictionary["at"] = at
        }
        if autoEstimates != nil{
            dictionary["auto_estimates"] = autoEstimates
        }
        if billable != nil{
            dictionary["billable"] = billable
        }
        if cid != nil{
            dictionary["cid"] = cid
        }
        if color != nil{
            dictionary["color"] = color
        }
        if createdAt != nil{
            dictionary["created_at"] = createdAt
        }
        if id != nil{
            dictionary["id"] = id
        }
        if isPrivate != nil{
            dictionary["is_private"] = isPrivate
        }
        if name != nil{
            dictionary["name"] = name
        }
        if template != nil{
            dictionary["template"] = template
        }
        if wid != nil{
            dictionary["wid"] = wid
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        active = aDecoder.decodeObjectForKey("active") as? Bool
        actualHours = aDecoder.decodeObjectForKey("actual_hours") as? Int
        at = aDecoder.decodeObjectForKey("at") as? String
        autoEstimates = aDecoder.decodeObjectForKey("auto_estimates") as? Bool
        billable = aDecoder.decodeObjectForKey("billable") as? Bool
        cid = aDecoder.decodeObjectForKey("cid") as? Int
        color = aDecoder.decodeObjectForKey("color") as? String
        createdAt = aDecoder.decodeObjectForKey("created_at") as? String
        id = aDecoder.decodeObjectForKey("id") as? Int
        isPrivate = aDecoder.decodeObjectForKey("is_private") as? Bool
        name = aDecoder.decodeObjectForKey("name") as? String
        template = aDecoder.decodeObjectForKey("template") as? Bool
        wid = aDecoder.decodeObjectForKey("wid") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encodeWithCoder(aCoder: NSCoder)
    {
        if active != nil{
            aCoder.encodeObject(active, forKey: "active")
        }
        if actualHours != nil{
            aCoder.encodeObject(actualHours, forKey: "actual_hours")
        }
        if at != nil{
            aCoder.encodeObject(at, forKey: "at")
        }
        if autoEstimates != nil{
            aCoder.encodeObject(autoEstimates, forKey: "auto_estimates")
        }
        if billable != nil{
            aCoder.encodeObject(billable, forKey: "billable")
        }
        if cid != nil{
            aCoder.encodeObject(cid, forKey: "cid")
        }
        if color != nil{
            aCoder.encodeObject(color, forKey: "color")
        }
        if createdAt != nil{
            aCoder.encodeObject(createdAt, forKey: "created_at")
        }
        if id != nil{
            aCoder.encodeObject(id, forKey: "id")
        }
        if isPrivate != nil{
            aCoder.encodeObject(isPrivate, forKey: "is_private")
        }
        if name != nil{
            aCoder.encodeObject(name, forKey: "name")
        }
        if template != nil{
            aCoder.encodeObject(template, forKey: "template")
        }
        if wid != nil{
            aCoder.encodeObject(wid, forKey: "wid")
        }
        
    }
    
}