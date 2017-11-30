//
//  CarePlanEvent.swift
//  KinveyCareKit
//
//  Created by Victor Barros on 2016-08-09.
//  Copyright © 2016 Kinvey. All rights reserved.
//

import Kinvey
import CareKit
import Realm
import ObjectMapper

class CarePlanEvent: Entity {
    
    var occurrenceIndexOfDay: UInt?
    var numberOfDaysSinceStart: UInt?
    var date: DateComponents?
    var activity: CarePlanActivity?
    var state: OCKCarePlanEventState?
    var result: CarePlanEventResult?
    
    init(event: OCKCarePlanEvent) {
        occurrenceIndexOfDay = event.occurrenceIndexOfDay
        numberOfDaysSinceStart = event.numberOfDaysSinceStart
        date = event.date
        activity = CarePlanActivity(event.activity)
        state = event.state
        if let result = event.result {
            self.result = CarePlanEventResult(result)
        }
        
        super.init()
    }
    
    override class func collectionName() -> String {
        return "Event"
    }

    
    required init?(map: Map) {
        var identifier: String?
        identifier <- (Entity.Key.entityId, map[Entity.Key.entityId])
        guard let _ = identifier else {
            super.init()
            return nil
        }
        
        super.init(map: map)
    }
    
    override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        
        occurrenceIndexOfDay <- ("occurrenceIndexOfDay", map["occurrenceIndexOfDay"])
        numberOfDaysSinceStart <- ("numberOfDaysSinceStart", map["numberOfDaysSinceStart"])
        date <- ("date", map["date"], NSDateComponentsTransform())
        activity <- ("activity", map["activity"])
        state <- ("state", map["state"], EnumTransform<OCKCarePlanEventState>())
        result <- ("result", map["result"])
    }
    
//    var ockCarePlanEvent: OCKCarePlanEvent? {
//        OCKCarePlanEvent(coder: <#T##NSCoder#>)
//    }

    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init() {
        super.init()
    }
    
}
