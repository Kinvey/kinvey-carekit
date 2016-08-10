//
//  CarePlanEvent.swift
//  KinveyCareKit
//
//  Created by Victor Barros on 2016-08-09.
//  Copyright © 2016 Kinvey. All rights reserved.
//

import Kinvey
import CareKit

class CarePlanEvent: Entity {
    
    var occurrenceIndexOfDay: UInt?
    var numberOfDaysSinceStart: UInt?
    var date: NSDateComponents?
    var activity: CarePlanActivity?
    var state: OCKCarePlanEventState?
    var result: OCKCarePlanEventResult?
    
//    init(event: OCKCarePlanEvent) {
//        occurrenceIndexOfDay = event.occurrenceIndexOfDay
//        numberOfDaysSinceStart = event.numberOfDaysSinceStart
//        date = event.date
//        activity = CarePlanActivity(event.activity)
//        state = event.state
//        result = event.result
//        
//        super.init()
//    }
    
    override class func collectionName() -> String {
        return "Event"
    }
    
}
