//
//  ContactInfo.swift
//  KinveyCareKit
//
//  Created by Victor Hugo Carvalho Barros on 2017-12-04.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import Kinvey
import CareKit
import ObjectMapper

public class ContactInfo: Entity {
    
    public var type: OCKContactInfoType?
    public var displayString: String?
    public var actionURL: URL?
    public var label: String?
    public var icon: UIImage?
    
    public convenience init(_ contactInfo: OCKContactInfo) {
        self.init()
        
        type = contactInfo.type
        displayString = contactInfo.displayString
        actionURL = contactInfo.actionURL
        label = contactInfo.label
        icon = contactInfo.icon
    }
    
    public override func propertyMapping(_ map: Map) {
        super.propertyMapping(map)
        
        type <- ("type", map["type"], EnumTransform<OCKContactInfoType>())
        displayString <- ("displayString", map["displayString"])
        actionURL <- ("actionURL", map["actionURL"])
        label <- ("label", map["label"])
        icon <- ("icon", map["icon"])
    }
    
}
