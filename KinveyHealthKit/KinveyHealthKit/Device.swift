//
//  Device.swift
//  KinveyHealthKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-12-01.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Kinvey
import HealthKit

class Device: Entity {
    
    var udiDeviceIdentifier: String?
    var firmwareVersion: String?
    var hardwareVersion: String?
    var localIdentifier: String?
    var manufacturer: String?
    var model: String?
    var name: String?
    var softwareVersion: String?
    
    convenience init?(_ device: HKDevice?) {
        guard let device = device else {
            return nil
        }
        
        self.init()
        udiDeviceIdentifier = device.udiDeviceIdentifier
        firmwareVersion = device.firmwareVersion
        hardwareVersion = device.hardwareVersion
        localIdentifier = device.localIdentifier
        manufacturer = device.manufacturer
        model = device.model
        name = device.name
        softwareVersion = device.softwareVersion
    }
    
    override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        
        udiDeviceIdentifier <- ("udiDeviceIdentifier", map["udiDeviceIdentifier"])
        firmwareVersion <- ("firmwareVersion", map["firmwareVersion"])
        hardwareVersion <- ("hardwareVersion", map["hardwareVersion"])
        localIdentifier <- ("localIdentifier", map["localIdentifier"])
        manufacturer <- ("manufacturer", map["manufacturer"])
        model <- ("model", map["model"])
        name <- ("name", map["name"])
        softwareVersion <- ("softwareVersion", map["softwareVersion"])
    }
    
}
