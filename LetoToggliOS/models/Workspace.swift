//
//	Workspace.swift
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Workspace : NSObject, NSCoding{

	var at : String!
	var id : Int!
	var name : String!
	var premium : Bool!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		at = dictionary["at"] as? String
		id = dictionary["id"] as? Int
		name = dictionary["name"] as? String
		premium = dictionary["premium"] as? Bool
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
		if id != nil{
			dictionary["id"] = id
		}
		if name != nil{
			dictionary["name"] = name
		}
		if premium != nil{
			dictionary["premium"] = premium
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
         id = aDecoder.decodeObjectForKey("id") as? Int
         name = aDecoder.decodeObjectForKey("name") as? String
         premium = aDecoder.decodeObjectForKey("premium") as? Bool

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
		if id != nil{
			aCoder.encodeObject(id, forKey: "id")
		}
		if name != nil{
			aCoder.encodeObject(name, forKey: "name")
		}
		if premium != nil{
			aCoder.encodeObject(premium, forKey: "premium")
		}

	}

}