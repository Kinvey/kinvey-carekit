//
//  QuantitySample.swift
//  KinveyHealthKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-12-01.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Kinvey
import HealthKit

class QuantitySample: Sample {
    
    var quantityType: QuantityType?
    var quantity: Quantity?
    
    convenience init(_ quantitySample: HKQuantitySample, unit: HKUnit? = nil) {
        self.init(quantitySample as HKSample)
        
        quantityType = QuantityType(quantitySample.quantityType)
        quantity = Quantity(quantitySample.quantity, unit: unit)
    }
    
//    override func propertyMapping(_ map: Map) {
//        super.propertyMapping(map)
//        
//        quantityType <- ("quantityType", map["quantityType"])
//        quantity <- ("quantity", map["quantity"])
//    }
    
}
