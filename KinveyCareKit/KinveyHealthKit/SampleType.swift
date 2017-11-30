//
//  SampleType.swift
//  KinveyCareKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-11-30.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Kinvey
import HealthKit
import ObjectMapper

class ObjectType: Entity {
    
    var identifier: String?
    
    convenience init(_ objectType: HKObjectType) {
        self.init()
        
        identifier = objectType.identifier
    }
    
    override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        
        identifier <- ("identifier", map["identifier"])
    }
    
}

class SampleType: ObjectType {
    
    convenience init(_ sampleType: HKSampleType) {
        self.init(sampleType as HKObjectType)
    }
    
}

class CategoryType: SampleType {
    
}

class CorrelationType: SampleType {
    
}

class QuantityType: SampleType {
    
    var aggregationStyle: HKQuantityAggregationStyle?
    
    convenience init(_ quantityType: HKQuantityType) {
        self.init(quantityType as HKSampleType)
        
        aggregationStyle = quantityType.aggregationStyle
    }
    
    override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        
        aggregationStyle <- ("aggregationStyle", map["aggregationStyle"], EnumTransform<HKQuantityAggregationStyle>())
    }
    
}

class WorkoutType: SampleType {
    
}
