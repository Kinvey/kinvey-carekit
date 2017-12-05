//
//  Extensions.swift
//  KinveyCareKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-12-05.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import ObjectMapper

extension Map {
    
    subscript<Enum: RawRepresentable>(_ key: Enum) -> Map where Enum.RawValue == String {
        return self[key.rawValue]
    }
    
    func value<Enum: RawRepresentable, R>(_ key: Enum) throws -> R where Enum.RawValue == String {
        return try value(key.rawValue)
    }
    
}
