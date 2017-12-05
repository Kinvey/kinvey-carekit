//
//  Contact.swift
//  KinveyCareKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-12-04.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Kinvey
import CareKit
import ObjectMapper

public class Contact: Entity {
    
    public var type: OCKContactType?
    public var name: String?
    public var relation: String?
    public var contactInfoItems: [ContactInfo]?
    public var tintColor: UIColor?
    public var monogram: String?
    public var image: UIImage?
    
    public convenience init(_ contact: OCKContact) {
        self.init()
        
        type = contact.type
        name = contact.name
        relation = contact.relation
        contactInfoItems = contact.contactInfoItems.map { ContactInfo($0) }
        tintColor = contact.tintColor
        monogram = contact.monogram
        image = contact.image
    }
    
    public var ockContact: OCKContact? {
        guard
            let type = type,
            let name = name,
            let relation = relation,
            let contactInfoItems = contactInfoItems
        else {
            return nil
        }
        
        return OCKContact(
            contactType: type,
            name: name,
            relation: relation,
            contactInfoItems: contactInfoItems.flatMap({ c in
                return nil
            }),
            tintColor: tintColor,
            monogram: monogram,
            image: image
        )
    }
    
    public override class func collectionName() -> String {
        return "Contact"
    }
    
    public override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        
        type <- ("type", map["type"], EnumTransform<OCKContactType>())
        name <- ("name", map["name"])
        relation <- ("relation", map["relation"])
        contactInfoItems <- ("contactInfoItems", map["contactInfoItems"], TransformOf<[ContactInfo], [[String : Any]]>(fromJSON: { (json) -> [ContactInfo]? in
            guard let json = json else {
                return nil
            }
            return [ContactInfo](JSONArray: json)
        }, toJSON: { (contactInfo) -> [[String : Any]]? in
            guard let contactInfo = contactInfo else {
                return nil
            }
            return contactInfo.toJSON()
        }))
        tintColor <- ("tintColor", map["tintColor"], UIColorTransform())
        monogram <- ("monogram", map["monogram"])
        image <- ("image", map["image"])
    }
    
}
