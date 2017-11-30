//
//  Quantity.swift
//  KinveyCareKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-11-30.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Kinvey
import HealthKit

class Quantity: Entity {
    
    var value: Double?
    var unit: String?
    
    convenience init?(_ quantity: HKQuantity, unit: HKUnit? = nil) {
        if let unit = unit, quantity.is(compatibleWith: unit) {
            self.init()
            value = quantity.doubleValue(for: unit)
            self.unit = unit.unitString
        } else {
            return nil
        }
    }
    
    override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        
        value <- ("value", map["value"])
        unit <- ("unit", map["unit"])
    }
    
}
