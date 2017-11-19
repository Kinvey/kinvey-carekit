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
    var startDate: DateComponents?
    var endDate: DateComponents?
    var occurrences: [NSNumber]?
    var timeUnitsToSkip: UInt?
    
    var ockCareSchedule: OCKCareSchedule? {
        if let startDate = startDate, let occurrences = occurrences, let timeUnitsToSkip = timeUnitsToSkip, let type = type {
            switch type {
            case .daily:
                return OCKCareSchedule.dailySchedule(withStartDate: startDate, occurrencesPerDay: occurrences.first!.uintValue, daysToSkip: timeUnitsToSkip, endDate: endDate)
            case .weekly:
                return OCKCareSchedule.weeklySchedule(withStartDate: startDate, occurrencesOnEachDay: occurrences, weeksToSkip: timeUnitsToSkip, endDate: endDate)
            case .other:
                break
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
    
    required init?(map: Map) {
        super.init(map: map)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init() {
        super.init()
    }
    
    override func propertyMapping(_ map: Map) {
        type <- ("type", map["type"])
        startDate <- ("startDate", map["startDate"], NSDateComponentsTransform())
        endDate <- ("endDate", map["endDate"], NSDateComponentsTransform())
        occurrences <- ("occurrences", map["occurrences"])
        timeUnitsToSkip <- ("timeUnitsToSkip", map["timeUnitsToSkip"])
    }
    
    override class func primaryKey() -> String? {
        return nil
    }
    
}
