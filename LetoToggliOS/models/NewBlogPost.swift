//
//	NewBlogPost.swift
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class NewBlogPost : NSObject, NSCoding{

	var title : String!
	var url : String!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		title = dictionary["title"] as? String
		url = dictionary["url"] as? String
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if title != nil{
			dictionary["title"] = title
		}
		if url != nil{
			dictionary["url"] = url
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         title = aDecoder.decodeObjectForKey("title") as? String
         url = aDecoder.decodeObjectForKey("url") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if title != nil{
			aCoder.encodeObject(title, forKey: "title")
		}
		if url != nil{
			aCoder.encodeObject(url, forKey: "url")
		}

	}

}