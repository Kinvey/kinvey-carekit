//
//  UserInfoTransform.swift
//  KinveyCareKit
//
//  Created by Tejas on 8/16/16.
//  Copyright © 2016 Kinvey. All rights reserved.
//

import Kinvey
import ObjectMapper

class UserInfoTransform: TransformOf<[String : NSCoding], [String : AnyObject]> {
    
    init() {
        super.init(fromJSON: { (json) -> [String: NSCoding]? in
            if let json = json {
                return json as? [String: NSCoding]
            }
            return nil
            }, toJSON: { (userInfo) -> [String : AnyObject]? in
                if let _ = userInfo {
                    return nil
                }
                return nil
        })
    }
    
}
