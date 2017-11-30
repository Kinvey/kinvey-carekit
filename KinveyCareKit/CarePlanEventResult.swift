//
//  CarePlanEventResult.swift
//  KinveyCareKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-11-29.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Kinvey
import CareKit

class CarePlanEventResult: Entity {
    
    var creationDate: Date?
    var valueString: String?
    var unitString: String?
    var values: [NSNumber]?
    var userInfo: [String : NSCoding]?
    
    var sampleUUID: String?
    var sampleType: SampleType?
    var displayUnit: String?
    var unitStringKeys: [String : String]?
    var categoryValueStringKeys: [NSNumber : String]?
    var sample: Sample?
    
    override class func collectionName() -> String {
        return "EventResult"
    }
    
    convenience init?(_ eventResult: OCKCarePlanEventResult?) {
        guard let eventResult = eventResult else {
            return nil
        }
        self.init(eventResult)
    }
    
    convenience init(_ eventResult: OCKCarePlanEventResult) {
        self.init()
        
        creationDate = eventResult.creationDate
        valueString = eventResult.valueString
        unitString = eventResult.unitString
        values = eventResult.values
        userInfo = eventResult.userInfo
        
        sampleUUID = eventResult.sampleUUID?.uuidString
        
        switch eventResult.sampleType {
        case let categoryType as HKCategoryType:
            break
        case let correlationType as HKCorrelationType:
            break
        case let quantityType as HKQuantityType:
            sampleType = QuantityType(quantityType)
        case let workoutType as HKWorkoutType:
            break
        default:
            break
        }
        
        displayUnit = eventResult.displayUnit?.unitString
        
        if let unitStringKeys = eventResult.unitStringKeys {
            self.unitStringKeys = [String : String](uniqueKeysWithValues: unitStringKeys.map({ (key, value) -> (String, String) in
                return (key.unitString, value)
            }))
        } else {
            unitStringKeys = nil
        }
        
        categoryValueStringKeys = eventResult.categoryValueStringKeys
        
        switch eventResult.sample {
        case let categorySample as HKCategorySample:
            break
        case let quantitySample as HKQuantitySample:
            sample = QuantitySample(quantitySample, unit: eventResult.displayUnit)
        case let correlation as HKCorrelation:
            break
        case let workout as HKWorkout:
            break
        default:
            break
        }
    }
    
    var ockCarePlanEventResult: OCKCarePlanEventResult? {
        guard
            let valueString = valueString,
            let unitString = unitString
        else {
            return nil
        }
        
        return OCKCarePlanEventResult(
            valueString: valueString,
            unitString: unitString,
            userInfo: userInfo,
            values: values
        )
    }
    
    override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        
        creationDate <- ("creationDate", map["creationDate"])
        valueString <- ("valueString", map["valueString"])
        unitString <- ("unitString", map["unitString"])
        values <- ("values", map["values"])
        userInfo <- ("userInfo", map["userInfo"])
        
        sampleUUID <- ("sampleUUID", map["sampleUUID"])
        sampleType <- ("sampleType", map["sampleType"])
        displayUnit <- ("displayUnit", map["displayUnit"])
        unitStringKeys <- ("unitStringKeys", map["unitStringKeys"])
        categoryValueStringKeys <- ("categoryValueStringKeys", map["categoryValueStringKeys"])
        sample <- ("sample", map["sample"])
    }

}
