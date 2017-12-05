//
//  Sample.swift
//  KinveyCareKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-11-30.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Kinvey
import HealthKit
import ObjectMapper

class Sample: KinveyHealthKitObject {
    
    var sampleType: SampleType?
    
    var startDate: Date?
    
    var endDate: Date?
    
    convenience init(_ sample: HKSample) {
        self.init()
        
        sampleType = SampleType(sample.sampleType)
        startDate = sample.startDate
        endDate = sample.endDate
    }    
    
//    sampleType <- ("sampleType", map["sampleType"])
//    startDate <- ("startDate", map["startDate"])
//    endDate <- ("endDate", map["endDate"])
    
}
