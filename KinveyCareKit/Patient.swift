//
//  Patient.swift
//  KinveyCareKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-12-04.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Kinvey
import CareKit
import ObjectMapper

public class Patient: Entity {
    
    public var name: String?
    public var detailInfo: String?
    public var careTeamContacts: [Contact]?
    public var tintColor: UIColor?
    public var monogram: String?
    public var image: UIImage?
    public var categories: [String]?
    public var userInfo: [String : Any]?
    
    public convenience init(_ patient: OCKPatient, careTeamContacts: [Contact]? = nil) {
        self.init()
        
        entityId = patient.identifier
        name = patient.name
        detailInfo = patient.detailInfo
        self.careTeamContacts = careTeamContacts ?? patient.careTeamContacts?.map { Contact($0) }
        tintColor = patient.tintColor
        monogram = patient.monogram
        image = patient.image
        categories = patient.categories
        userInfo = patient.userInfo
    }
    
    public override class func collectionName() -> String {
        return "Patient"
    }
    
    public override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        
        name <- ("name", map["name"])
        detailInfo <- ("detailInfo", map["detailInfo"])
        careTeamContacts <- ("careTeamContacts", map["careTeamContacts"], TransformOf<[Contact], [[String : Any]]>(fromJSON: { (json) -> [Contact]? in
            guard let json = json else {
                return nil
            }
            return [Contact](JSONArray: json)
        }, toJSON: { (contact) -> [[String : Any]]? in
            guard let contact = contact else {
                return nil
            }
            return contact.toJSON()
        }))
        tintColor <- ("tintColor", map["tintColor"], UIColorTransform())
        monogram <- ("monogram", map["monogram"])
        image <- ("image", map["image"])
        categories <- ("categories", map["categories"])
        userInfo <- ("userInfo", map["userInfo"])
    }
    
}
