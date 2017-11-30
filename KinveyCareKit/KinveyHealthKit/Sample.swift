//
//  Sample.swift
//  KinveyCareKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-11-30.
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

class Object: Entity {
    
    var hkMetadata: [String : Any]?
    var device: Device?
    
    convenience init(_ object: HKObject) {
        self.init()
        
        entityId = object.uuid.uuidString
        hkMetadata = object.metadata
        device = Device(object.device)
    }
    
    override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        
        hkMetadata <- ("hkMetadata", map["metadata"])
        device <- ("device", map["device"])
    }
    
}

class Sample: Object {
    
    var sampleType: SampleType?
    
    var startDate: Date?
    
    var endDate: Date?
    
    convenience init(_ sample: HKSample) {
        self.init()
        
        sampleType = SampleType(sample.sampleType)
        startDate = sample.startDate
        endDate = sample.endDate
    }
    
    override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        
        sampleType <- ("sampleType", map["sampleType"])
        startDate <- ("startDate", map["startDate"])
        endDate <- ("endDate", map["endDate"])
    }
    
}

class QuantitySample: Sample {
    
    var quantityType: QuantityType?
    var quantity: Quantity?
    
    convenience init(_ quantitySample: HKQuantitySample, unit: HKUnit? = nil) {
        self.init(quantitySample as HKSample)
        
        quantityType = QuantityType(quantitySample.quantityType)
        quantity = Quantity(quantitySample.quantity, unit: unit)
    }
    
    override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        
        quantityType <- ("quantityType", map["quantityType"])
        quantity <- ("quantity", map["quantity"])
    }
    
}
