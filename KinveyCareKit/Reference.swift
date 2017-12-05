//
//  Reference.swift
//  KinveyCareKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-12-05.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Kinvey
import ObjectMapper

struct Reference<T: Entity>: ImmutableMappable {
    
    let collection: String
    let id: String
    
    enum EncodingKeys: String {
        
        case collection
        case id = "_id"
        
    }
    
    init(map: Map) throws {
        collection = try map.value(EncodingKeys.collection)
        id = try map.value(EncodingKeys.id)
    }
    
    init?(_ reference: T) {
        guard let entityId = reference.entityId else {
            return nil
        }
        
        collection = T.collectionName()
        id = entityId
    }
    
    func mapping(map: Map) {
        collection >>> map[EncodingKeys.collection]
        id >>> map[EncodingKeys.id]
    }
    
}
