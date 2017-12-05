//
//  ObjectType.swift
//  KinveyHealthKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-12-01.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Kinvey
import HealthKit

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
