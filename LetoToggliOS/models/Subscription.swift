//
//	Subscription.swift
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class Subscription : NSObject, NSCoding{

	var createdAt : String!
	var deletedAt : AnyObject!
	var descriptionField : String!
	var updatedAt : AnyObject!
	var vatApplicable : Bool!
	var vatInvalidAcceptedAt : AnyObject!
	var vatInvalidAcceptedBy : AnyObject!
	var vatValid : Bool!
	var vatValidatedAt : AnyObject!
	var workspaceId : Int!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		createdAt = dictionary["created_at"] as? String
		deletedAt = dictionary["deleted_at"] as? String
		descriptionField = dictionary["description"] as? String
		updatedAt = dictionary["updated_at"] as? String
		vatApplicable = dictionary["vat_applicable"] as? Bool
		vatInvalidAcceptedAt = dictionary["vat_invalid_accepted_at"] as? String
		vatInvalidAcceptedBy = dictionary["vat_invalid_accepted_by"] as? String
		vatValid = dictionary["vat_valid"] as? Bool
		vatValidatedAt = dictionary["vat_validated_at"] as? String
		workspaceId = dictionary["workspace_id"] as? Int
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if createdAt != nil{
			dictionary["created_at"] = createdAt
		}
		if deletedAt != nil{
			dictionary["deleted_at"] = deletedAt
		}
		if descriptionField != nil{
			dictionary["description"] = descriptionField
		}
		if updatedAt != nil{
			dictionary["updated_at"] = updatedAt
		}
		if vatApplicable != nil{
			dictionary["vat_applicable"] = vatApplicable
		}
		if vatInvalidAcceptedAt != nil{
			dictionary["vat_invalid_accepted_at"] = vatInvalidAcceptedAt
		}
		if vatInvalidAcceptedBy != nil{
			dictionary["vat_invalid_accepted_by"] = vatInvalidAcceptedBy
		}
		if vatValid != nil{
			dictionary["vat_valid"] = vatValid
		}
		if vatValidatedAt != nil{
			dictionary["vat_validated_at"] = vatValidatedAt
		}
		if workspaceId != nil{
			dictionary["workspace_id"] = workspaceId
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         createdAt = aDecoder.decodeObjectForKey("created_at") as? String
         deletedAt = aDecoder.decodeObjectForKey("deleted_at") as? String
         descriptionField = aDecoder.decodeObjectForKey("description") as? String
         updatedAt = aDecoder.decodeObjectForKey("updated_at") as? String
         vatApplicable = aDecoder.decodeObjectForKey("vat_applicable") as? Bool
         vatInvalidAcceptedAt = aDecoder.decodeObjectForKey("vat_invalid_accepted_at") as? String
         vatInvalidAcceptedBy = aDecoder.decodeObjectForKey("vat_invalid_accepted_by") as? String
         vatValid = aDecoder.decodeObjectForKey("vat_valid") as? Bool
         vatValidatedAt = aDecoder.decodeObjectForKey("vat_validated_at") as? String
         workspaceId = aDecoder.decodeObjectForKey("workspace_id") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encodeWithCoder(aCoder: NSCoder)
	{
		if createdAt != nil{
			aCoder.encodeObject(createdAt, forKey: "created_at")
		}
		if deletedAt != nil{
			aCoder.encodeObject(deletedAt, forKey: "deleted_at")
		}
		if descriptionField != nil{
			aCoder.encodeObject(descriptionField, forKey: "description")
		}
		if updatedAt != nil{
			aCoder.encodeObject(updatedAt, forKey: "updated_at")
		}
		if vatApplicable != nil{
			aCoder.encodeObject(vatApplicable, forKey: "vat_applicable")
		}
		if vatInvalidAcceptedAt != nil{
			aCoder.encodeObject(vatInvalidAcceptedAt, forKey: "vat_invalid_accepted_at")
		}
		if vatInvalidAcceptedBy != nil{
			aCoder.encodeObject(vatInvalidAcceptedBy, forKey: "vat_invalid_accepted_by")
		}
		if vatValid != nil{
			aCoder.encodeObject(vatValid, forKey: "vat_valid")
		}
		if vatValidatedAt != nil{
			aCoder.encodeObject(vatValidatedAt, forKey: "vat_validated_at")
		}
		if workspaceId != nil{
			aCoder.encodeObject(workspaceId, forKey: "workspace_id")
		}

	}

}