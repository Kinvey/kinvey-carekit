//
//  CarePlanThreshold.swift
//  KinveyCareKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-11-27.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import ObjectMapper
import CareKit
import Kinvey

class CarePlanThreshold: Entity {
    
    var type: OCKCarePlanThresholdType?
    var value: NSNumber?
    var title: String?
    var upperValue: NSNumber?
    
    convenience init(_ planThreshold: OCKCarePlanThreshold) {
        self.init()
        
        self.type = planThreshold.type
        self.value = planThreshold.value
        self.title = planThreshold.title
        self.upperValue = planThreshold.upperValue
    }
    
    override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        
        type <- map["type"]
        value <- map["value"]
        title <- map["title"]
        upperValue <- map["upperValue"]
    }
    
    var ockCarePlanThreshold: OCKCarePlanThreshold? {
        guard let value = value, let type = type else {
            return nil
        }
        
        return OCKCarePlanThreshold.numericThreshold(
            withValue: value,
            type: type,
            upperValue: upperValue,
            title: title
        )
    }
    
}
