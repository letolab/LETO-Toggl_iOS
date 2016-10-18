//
//	Obm.swift
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Obm : NSObject, NSCoding{

	var included : Bool!
	var nr : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		included = dictionary["included"] as? Bool
		nr = dictionary["nr"] as? Int
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if included != nil{
			dictionary["included"] = included
		}
		if nr != nil{
			dictionary["nr"] = nr
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         included = aDecoder.decodeObjectForKey("included") as? Bool
         nr = aDecoder.decodeObjectForKey("nr") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if included != nil{
			aCoder.encodeObject(included, forKey: "included")
		}
		if nr != nil{
			aCoder.encodeObject(nr, forKey: "nr")
		}

	}

}