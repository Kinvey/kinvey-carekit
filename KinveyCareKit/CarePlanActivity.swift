//
//  CarePlanActivity.swift
//  KinveyCareKit
//
//  Created by Victor Barros on 2016-08-08.
//  Copyright © 2016 Kinvey. All rights reserved.
//

import Kinvey
import CareKit
import Realm

class CarePlanActivity: Entity {
    
    var identifier: String?
    var groupIdentifier: String?
    var type: OCKCarePlanActivityType?
    var title: String?
    var text: String?
    var tintColor: UIColor?
    var instructions: String?
    var imageURL: NSURL?
    var schedule: CareSchedule?
    var resultResettable: Bool?
    var userInfo: [String : NSCoding]?
    
    init(_ activity: OCKCarePlanActivity) {
        identifier = activity.identifier
        groupIdentifier = activity.groupIdentifier
        type = activity.type
        title = activity.title
        text = activity.text
        tintColor = activity.tintColor
        instructions = activity.instructions
        imageURL = activity.imageURL
        schedule = CareSchedule(activity.schedule)
        resultResettable = activity.resultResettable
        userInfo = activity.userInfo
        
        super.init()
    }
    
    required init?(_ map: Map) {
        var identifier: String?
        identifier <- map[PersistableIdKey]
        guard let _ = identifier else {
            super.init()
            return nil
        }
        
        super.init(map)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: AnyObject, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init() {
        super.init()
    }
    
    override class func collectionName() -> String {
        return "Activity"
    }
    
    override func propertyMapping(map: Map) {
        identifier <- ("identifier", map[PersistableIdKey])
        groupIdentifier <- map["groupIdentifier"]
        //type <- map["type"]
        title <- map["title"]
        text <- map["text"]
        tintColor <- (map["tintColor"], UIColorTransform())
        instructions <- map["instructions"]
        imageURL <- map["imageURL"]
        //schedule <- map["schedule"]
        resultResettable <- map["resultResettable"]
        //userInfo <- map["userInfo"]
    }
    
    var ockCarePlanActivity: OCKCarePlanActivity? {
        return OCKCarePlanActivity(identifier: self.identifier!,
                                   groupIdentifier: self.groupIdentifier,
                                   type: self.type!,
                                   title: self.title!,
                                   text: self.text,
                                   tintColor: self.tintColor,
                                   instructions: self.instructions,
                                   imageURL: self.imageURL,
                                   schedule: self.schedule!.ockCareSchedule!,
                                   resultResettable: self.resultResettable!,
                                   userInfo: self.userInfo)
    }
    
}
