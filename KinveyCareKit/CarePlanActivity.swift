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
    var optional: Bool?
    
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
        optional = activity.optional
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
        optional <- ("optional", map["optional"])
    }
    
    var ockCarePlanActivity: OCKCarePlanActivity? {
        return OCKCarePlanActivity(
            identifier: entityId!,
            groupIdentifier: groupIdentifier,
            type: type!,
            title: title!,
            text: text,
            tintColor: tintColor,
            instructions: instructions,
            imageURL: imageURL,
            schedule: schedule!.ockCareSchedule!,
            resultResettable: resultResettable!,
            userInfo: userInfo,
            thresholds: nil,
            optional: optional ?? false
        )
    }
}
