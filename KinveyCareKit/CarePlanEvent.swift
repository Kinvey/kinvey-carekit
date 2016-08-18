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

class CarePlanEvent: Entity {
    
    var occurrenceIndexOfDay: UInt?
    var numberOfDaysSinceStart: UInt?
    var date: NSDateComponents?
    var activity: CarePlanActivity?
    var state: OCKCarePlanEventState?
    var result: OCKCarePlanEventResult?
    
    init(event: OCKCarePlanEvent) {
        occurrenceIndexOfDay = event.occurrenceIndexOfDay
        numberOfDaysSinceStart = event.numberOfDaysSinceStart
        date = event.date
        activity = CarePlanActivity(event.activity)
        state = event.state
        result = event.result
        
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
    
}
