//
//  KinveyHealthKit.swift
//  KinveyCareKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-11-30.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import HealthKit

public var defaultMassUnit = HKUnit.gram()
public var defaultLengthUnit = HKUnit.meter()
public var defaultVolumeUnit = HKUnit.liter()
public var defaultPressureUnit = HKUnit.pascal()
public var defaultTimeUnit = HKUnit.second()
public var defaultEnergyUnit = HKUnit.joule()
public var defaultTemperatureUnit = HKUnit.kelvin()
public var defaultElectricalConductanceUnit = HKUnit.siemen()

@available(iOS 11.0, *)
public var defaultPharmacology = HKUnit.internationalUnit()
