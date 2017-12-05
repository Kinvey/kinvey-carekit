//
//  Source.swift
//  KinveyHealthKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-12-01.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import RealmSwift
import HealthKit
import ObjectMapper

class Source: Object, StaticMappable {
    
    var name: String?
    var bundleIdentifier: String?
    
    convenience init(_ source: HKSource) {
        self.init()
        
        name = source.name
        bundleIdentifier = source.bundleIdentifier
    }
    
    static func objectForMapping(map: Map) -> BaseMappable? {
        return Source()
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        bundleIdentifier <- map["bundleIdentifier"]
    }
    
}
