//
//	Data.swift
//	Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation


class UserData : NSObject, NSCoding{

    var apiToken : String!
    var at : String!
    var beginningOfWeek : Int!
    var clients : [Client]!
    var dateFormat : String!
    var defaultWid : Int!
    var email : String!
    var fullname : String!
    var id : Int!
    var imageUrl : String!
    var jqueryDateFormat : String!
    var jqueryTimeofdayFormat : String!
    var language : String!
    var newBlogPost : NewBlogPost!
    var projects : [Project]!
    var recordTimeline : Bool!
    var renderTimeline : Bool!
    var retention : Int!
    var sidebarPiechart : Bool!
    var storeStartAndStopTime : Bool!
    var tags : [Client]!
    var timeEntries : [TimeEntry]!
    var timelineEnabled : Bool!
    var timelineExperiment : Bool!
    var timeofdayFormat : String!
    var workspaces : [Workspace]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: NSDictionary){
        apiToken = dictionary["api_token"] as? String
        at = dictionary["at"] as? String
        beginningOfWeek = dictionary["beginning_of_week"] as? Int
        clients = [Client]()
        if let clientsArray = dictionary["clients"] as? [NSDictionary]{
            for dic in clientsArray{
                let value = Client(fromDictionary: dic)
                clients.append(value)
            }
        }
        dateFormat = dictionary["date_format"] as? String
        defaultWid = dictionary["default_wid"] as? Int
        email = dictionary["email"] as? String
        fullname = dictionary["fullname"] as? String
        id = dictionary["id"] as? Int
        imageUrl = dictionary["image_url"] as? String
        jqueryDateFormat = dictionary["jquery_date_format"] as? String
        jqueryTimeofdayFormat = dictionary["jquery_timeofday_format"] as? String
        language = dictionary["language"] as? String
        if let newBlogPostData = dictionary["new_blog_post"] as? NSDictionary{
            newBlogPost = NewBlogPost(fromDictionary: newBlogPostData)
        }
        projects = [Project]()
        if let projectsArray = dictionary["projects"] as? [NSDictionary]{
            for dic in projectsArray{
                let value = Project(fromDictionary: dic)
                projects.append(value)
            }
        }
        recordTimeline = dictionary["record_timeline"] as? Bool
        renderTimeline = dictionary["render_timeline"] as? Bool
        retention = dictionary["retention"] as? Int
        sidebarPiechart = dictionary["sidebar_piechart"] as? Bool
        storeStartAndStopTime = dictionary["store_start_and_stop_time"] as? Bool
        tags = [Client]()
        if let tagsArray = dictionary["tags"] as? [NSDictionary]{
            for dic in tagsArray{
                let value = Client(fromDictionary: dic)
                tags.append(value)
            }
        }
        timeEntries = [TimeEntry]()
        if let timeEntriesArray = dictionary["time_entries"] as? [NSDictionary]{
            for dic in timeEntriesArray{
                let value = TimeEntry(fromDictionary: dic)
                timeEntries.append(value)
            }
        }
        timelineEnabled = dictionary["timeline_enabled"] as? Bool
        timelineExperiment = dictionary["timeline_experiment"] as? Bool
        timeofdayFormat = dictionary["timeofday_format"] as? String
        workspaces = [Workspace]()
        if let workspacesArray = dictionary["workspaces"] as? [NSDictionary]{
            for dic in workspacesArray{
                let value = Workspace(fromDictionary: dic)
                workspaces.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> NSDictionary
    {
        let dictionary = NSMutableDictionary()
        if apiToken != nil{
            dictionary["api_token"] = apiToken
        }
        if at != nil{
            dictionary["at"] = at
        }
        if beginningOfWeek != nil{
            dictionary["beginning_of_week"] = beginningOfWeek
        }
        if clients != nil{
            var dictionaryElements = [NSDictionary]()
            for clientsElement in clients {
                dictionaryElements.append(clientsElement.toDictionary())
            }
            dictionary["clients"] = dictionaryElements
        }
        if dateFormat != nil{
            dictionary["date_format"] = dateFormat
        }
        if defaultWid != nil{
            dictionary["default_wid"] = defaultWid
        }
        if email != nil{
            dictionary["email"] = email
        }
        if fullname != nil{
            dictionary["fullname"] = fullname
        }
        if id != nil{
            dictionary["id"] = id
        }
        if imageUrl != nil{
            dictionary["image_url"] = imageUrl
        }
        if jqueryDateFormat != nil{
            dictionary["jquery_date_format"] = jqueryDateFormat
        }
        if jqueryTimeofdayFormat != nil{
            dictionary["jquery_timeofday_format"] = jqueryTimeofdayFormat
        }
        if language != nil{
            dictionary["language"] = language
        }
        if newBlogPost != nil{
            dictionary["new_blog_post"] = newBlogPost.toDictionary()
        }
        if projects != nil{
            var dictionaryElements = [NSDictionary]()
            for projectsElement in projects {
                dictionaryElements.append(projectsElement.toDictionary())
            }
            dictionary["projects"] = dictionaryElements
        }
        if recordTimeline != nil{
            dictionary["record_timeline"] = recordTimeline
        }
        if renderTimeline != nil{
            dictionary["render_timeline"] = renderTimeline
        }
        if retention != nil{
            dictionary["retention"] = retention
        }
        if sidebarPiechart != nil{
            dictionary["sidebar_piechart"] = sidebarPiechart
        }
        if storeStartAndStopTime != nil{
            dictionary["store_start_and_stop_time"] = storeStartAndStopTime
        }
        if tags != nil{
            var dictionaryElements = [NSDictionary]()
            for tagsElement in tags {
                dictionaryElements.append(tagsElement.toDictionary())
            }
            dictionary["tags"] = dictionaryElements
        }
        if timeEntries != nil{
            var dictionaryElements = [NSDictionary]()
            for timeEntriesElement in timeEntries {
                dictionaryElements.append(timeEntriesElement.toDictionary())
            }
            dictionary["time_entries"] = dictionaryElements
        }
        if timelineEnabled != nil{
            dictionary["timeline_enabled"] = timelineEnabled
        }
        if timelineExperiment != nil{
            dictionary["timeline_experiment"] = timelineExperiment
        }
        if timeofdayFormat != nil{
            dictionary["timeofday_format"] = timeofdayFormat
        }
        if workspaces != nil{
            var dictionaryElements = [NSDictionary]()
            for workspacesElement in workspaces {
                dictionaryElements.append(workspacesElement.toDictionary())
            }
            dictionary["workspaces"] = dictionaryElements
        }
        return dictionary
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        apiToken = aDecoder.decodeObjectForKey("api_token") as? String
        at = aDecoder.decodeObjectForKey("at") as? String
        beginningOfWeek = aDecoder.decodeObjectForKey("beginning_of_week") as? Int
        clients = aDecoder.decodeObjectForKey("clients") as? [Client]
        dateFormat = aDecoder.decodeObjectForKey("date_format") as? String
        defaultWid = aDecoder.decodeObjectForKey("default_wid") as? Int
        email = aDecoder.decodeObjectForKey("email") as? String
        fullname = aDecoder.decodeObjectForKey("fullname") as? String
        id = aDecoder.decodeObjectForKey("id") as? Int
        imageUrl = aDecoder.decodeObjectForKey("image_url") as? String
        jqueryDateFormat = aDecoder.decodeObjectForKey("jquery_date_format") as? String
        jqueryTimeofdayFormat = aDecoder.decodeObjectForKey("jquery_timeofday_format") as? String
        language = aDecoder.decodeObjectForKey("language") as? String
        newBlogPost = aDecoder.decodeObjectForKey("new_blog_post") as? NewBlogPost
        projects = aDecoder.decodeObjectForKey("projects") as? [Project]
        recordTimeline = aDecoder.decodeObjectForKey("record_timeline") as? Bool
        renderTimeline = aDecoder.decodeObjectForKey("render_timeline") as? Bool
        retention = aDecoder.decodeObjectForKey("retention") as? Int
        sidebarPiechart = aDecoder.decodeObjectForKey("sidebar_piechart") as? Bool
        storeStartAndStopTime = aDecoder.decodeObjectForKey("store_start_and_stop_time") as? Bool
        tags = aDecoder.decodeObjectForKey("tags") as? [Client]
        timeEntries = aDecoder.decodeObjectForKey("time_entries") as? [TimeEntry]
        timelineEnabled = aDecoder.decodeObjectForKey("timeline_enabled") as? Bool
        timelineExperiment = aDecoder.decodeObjectForKey("timeline_experiment") as? Bool
        timeofdayFormat = aDecoder.decodeObjectForKey("timeofday_format") as? String
        workspaces = aDecoder.decodeObjectForKey("workspaces") as? [Workspace]
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encodeWithCoder(aCoder: NSCoder)
    {
        if apiToken != nil{
            aCoder.encodeObject(apiToken, forKey: "api_token")
        }
        if at != nil{
            aCoder.encodeObject(at, forKey: "at")
        }
        if beginningOfWeek != nil{
            aCoder.encodeObject(beginningOfWeek, forKey: "beginning_of_week")
        }
        if clients != nil{
            aCoder.encodeObject(clients, forKey: "clients")
        }
        if dateFormat != nil{
            aCoder.encodeObject(dateFormat, forKey: "date_format")
        }
        if defaultWid != nil{
            aCoder.encodeObject(defaultWid, forKey: "default_wid")
        }
        if email != nil{
            aCoder.encodeObject(email, forKey: "email")
        }
        if fullname != nil{
            aCoder.encodeObject(fullname, forKey: "fullname")
        }
        if id != nil{
            aCoder.encodeObject(id, forKey: "id")
        }
        if imageUrl != nil{
            aCoder.encodeObject(imageUrl, forKey: "image_url")
        }
        if jqueryDateFormat != nil{
            aCoder.encodeObject(jqueryDateFormat, forKey: "jquery_date_format")
        }
        if jqueryTimeofdayFormat != nil{
            aCoder.encodeObject(jqueryTimeofdayFormat, forKey: "jquery_timeofday_format")
        }
        if language != nil{
            aCoder.encodeObject(language, forKey: "language")
        }
        if newBlogPost != nil{
            aCoder.encodeObject(newBlogPost, forKey: "new_blog_post")
        }
        if projects != nil{
            aCoder.encodeObject(projects, forKey: "projects")
        }
        if recordTimeline != nil{
            aCoder.encodeObject(recordTimeline, forKey: "record_timeline")
        }
        if renderTimeline != nil{
            aCoder.encodeObject(renderTimeline, forKey: "render_timeline")
        }
        if retention != nil{
            aCoder.encodeObject(retention, forKey: "retention")
        }
        if sidebarPiechart != nil{
            aCoder.encodeObject(sidebarPiechart, forKey: "sidebar_piechart")
        }
        if storeStartAndStopTime != nil{
            aCoder.encodeObject(storeStartAndStopTime, forKey: "store_start_and_stop_time")
        }
        if tags != nil{
            aCoder.encodeObject(tags, forKey: "tags")
        }
        if timeEntries != nil{
            aCoder.encodeObject(timeEntries, forKey: "time_entries")
        }
        if timelineEnabled != nil{
            aCoder.encodeObject(timelineEnabled, forKey: "timeline_enabled")
        }
        if timelineExperiment != nil{
            aCoder.encodeObject(timelineExperiment, forKey: "timeline_experiment")
        }
        if timeofdayFormat != nil{
            aCoder.encodeObject(timeofdayFormat, forKey: "timeofday_format")
        }
        if workspaces != nil{
            aCoder.encodeObject(workspaces, forKey: "workspaces")
        }
        
    }
    
}