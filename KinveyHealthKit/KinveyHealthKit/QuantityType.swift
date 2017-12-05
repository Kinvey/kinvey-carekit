//
//  QuantityType.swift
//  KinveyHealthKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-12-01.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Kinvey
import HealthKit
import ObjectMapper

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
