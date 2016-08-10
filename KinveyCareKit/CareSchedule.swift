//
//  CareSchedule.swift
//  KinveyCareKit
//
//  Created by Victor Barros on 2016-08-09.
//  Copyright © 2016 Kinvey. All rights reserved.
//

import Kinvey
import CareKit
import Realm

class CareSchedule: Entity {
    
    var type: OCKCareScheduleType?
    var startDate: NSDateComponents?
    var endDate: NSDateComponents?
    var occurrences: [NSNumber]?
    var timeUnitsToSkip: UInt?
    
    var ockCareSchedule: OCKCareSchedule? {
        if let startDate = startDate, let occurrences = occurrences, let timeUnitsToSkip = timeUnitsToSkip {
            if type == .Daily {
                return OCKCareSchedule.dailyScheduleWithStartDate(startDate, occurrencesPerDay: occurrences.first!.unsignedLongValue, daysToSkip: timeUnitsToSkip, endDate: endDate)
            } else if type == .Weekly {
                return OCKCareSchedule.weeklyScheduleWithStartDate(startDate, occurrencesOnEachDay: occurrences, weeksToSkip: timeUnitsToSkip, endDate: endDate)
            }
        }
        return nil
    }
    
    init(_ schedule: OCKCareSchedule) {
        type = schedule.type
        startDate = schedule.startDate
        endDate = schedule.endDate
        occurrences = schedule.occurrences
        timeUnitsToSkip = schedule.timeUnitsToSkip
        
        super.init()
    }
    
    required init?(_ map: Map) {
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
    
    override func propertyMapping(map: Map) {
        type <- map["type"]
        startDate <- (map["startDate"], NSDateComponentsTransform())
        endDate <- (map["endDate"], NSDateComponentsTransform())
        occurrences <- map["occurrences"]
        timeUnitsToSkip <- map["timeUnitsToSkip"]
    }
    
    override class func primaryKey() -> String? {
        return nil
    }
    
}
