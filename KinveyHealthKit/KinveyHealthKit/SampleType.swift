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

class SampleType: ObjectType {
    
    convenience init(_ sampleType: HKSampleType) {
        self.init(sampleType as HKObjectType)
    }
    
}
