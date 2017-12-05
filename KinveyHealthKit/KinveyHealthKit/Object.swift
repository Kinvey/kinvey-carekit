//
//  Object.swift
//  KinveyHealthKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-12-01.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import RealmSwift
import ObjectMapper
import HealthKit

class KinveyHealthKitObject: Object, StaticMappable {
    
    var uuid: String?
    var source: Source?
    var sourceRevision: SourceRevision?
    var metadata: [String : Any]?
    var device: Device?
    
    convenience init(_ object: HKObject) {
        self.init()
        
        uuid = object.uuid.uuidString
        source = Source(object.source)
        metadata = object.metadata
        device = Device(object.device)
    }
    
    static func objectForMapping(map: Map) -> BaseMappable? {
        return KinveyHealthKitObject()
    }
    
    func mapping(map: Map) {
        uuid <- map["uuid"]
        source <- map["source"]
        metadata <- map["metadata"]
        device <- map["device"]
    }
    
}
