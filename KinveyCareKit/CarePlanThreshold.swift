//
//  CarePlanThreshold.swift
//  KinveyCareKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-11-27.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import ObjectMapper
import CareKit
import Realm
import RealmSwift

class CarePlanThreshold: Object, Mappable {
    
    var type: OCKCarePlanThresholdType = OCKCarePlanThresholdType.adherance
    var value: NSNumber = 0
    var title: String?
    var upperValue: NSNumber?
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    init(_ planThreshold: OCKCarePlanThreshold) {
        self.type = planThreshold.type
        self.value = planThreshold.value
        self.title = planThreshold.title
        self.upperValue = planThreshold.upperValue
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init() {
        super.init()
    }
    
    func mapping(map: Map) {
        type <- map["type"]
        value <- map["value"]
        title <- map["title"]
        upperValue <- map["upperValue"]
    }
    
    var ockCarePlanThreshold: OCKCarePlanThreshold {
        return OCKCarePlanThreshold.numericThreshold(
            withValue: value,
            type: type,
            upperValue: upperValue,
            title: title
        )
    }
    
}
