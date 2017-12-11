//
//  Reference.swift
//  KinveyCareKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-12-05.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Kinvey
import ObjectMapper

public protocol Referenceable {
    
    var collection: String { get }
    var id: String { get }
    
}

extension Entity: Referenceable {
    
    public var collection: String {
        return type(of: self).collectionName()
    }
    
    public var id: String {
        return entityId!
    }
    
}

extension User: Referenceable {
    
    public var collection: String {
        return "_user"
    }
    
    public var id: String {
        return userId
    }
    
}

public struct Reference<T: Referenceable>: ImmutableMappable {
    
    let collection: String
    let id: String
    
    enum EncodingKeys: String {
        
        case collection
        case id = "_id"
        
    }
    
    public init(map: Map) throws {
        collection = try map.value(EncodingKeys.collection)
        id = try map.value(EncodingKeys.id)
    }
    
    public init?(_ reference: T?) {
        guard let reference = reference else {
            return nil
        }
        
        collection = reference.collection
        id = reference.id
    }
    
    public func mapping(map: Map) {
        collection >>> map[EncodingKeys.collection]
        id >>> map[EncodingKeys.id]
    }
    
}
