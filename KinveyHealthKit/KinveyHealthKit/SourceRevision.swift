//
//  SourceRevision.swift
//  KinveyHealthKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-12-01.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import RealmSwift
import ObjectMapper
import HealthKit

@available(iOS 9.0, *)
class SourceRevision: Object, StaticMappable {
    
    var source: Source?
    var version: String?
    
//    @available(iOS 11.0, *)
    var productType: String?
    
    convenience init(_ sourceRevision: HKSourceRevision) {
        self.init()
        
        source = Source(sourceRevision.source)
        version = sourceRevision.version
        
        if #available(iOS 11.0, *) {
            productType = sourceRevision.productType
        }
    }
    
    static func objectForMapping(map: Map) -> BaseMappable? {
        return SourceRevision()
    }
    
    func mapping(map: Map) {
        source <- map["source"]
        version <- map["version"]
        productType <- map["productType"]
    }
    
}
