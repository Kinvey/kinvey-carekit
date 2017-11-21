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
import ObjectMapper

class CarePlanActivity: Entity {
    
    //var identifier: String?
    var groupIdentifier: String?
    var type: OCKCarePlanActivityType?
    var title: String?
    var text: String?
    var tintColor: UIColor?
    var instructions: String?
    var imageURL: URL?
    var schedule: CareSchedule?
    var resultResettable: Bool?
    var userInfo: [String : NSCoding]?
    
    convenience init(_ activity: OCKCarePlanActivity) {
        self.init()
        
        entityId = activity.identifier
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
        
    }
    
    override class func collectionName() -> String {
        return "Activity"
    }
    
    override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        
        groupIdentifier <- ("groupIdentifier", map["groupIdentifier"])
        type <- ("type", map["type"], EnumTransform<OCKCarePlanActivityType>())
        title <- ("title", map["title"])
        text <- ("text", map["text"])
        tintColor <- ("tintColor", map["tintColor"], UIColorTransform())
        instructions <- ("instructions", map["instructions"])
        imageURL <- ("imageURL", map["imageURL"])
        schedule <- ("schedule", map["schedule"])
        resultResettable <- ("resultResettable", map["resultResettable"])
        userInfo <- ("userInfo", map["userInfo"], UserInfoTransform())
    }
    
    var ockCarePlanActivity: OCKCarePlanActivity? {
        return OCKCarePlanActivity(
            identifier: self.entityId!,
            groupIdentifier: self.groupIdentifier,
            type: self.type!,
            title: self.title!,
            text: self.text,
            tintColor: self.tintColor,
            instructions: self.instructions,
            imageURL: self.imageURL,
            schedule: self.schedule!.ockCareSchedule!,
            resultResettable: self.resultResettable!,
            userInfo: self.userInfo
        )
    }
}
