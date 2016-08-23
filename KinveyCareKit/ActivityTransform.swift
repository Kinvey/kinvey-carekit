//
//  ActivityTransform.swift
//  KinveyCareKit
//
//  Created by Tejas on 8/22/16.
//  Copyright © 2016 Kinvey. All rights reserved.
//

import Kinvey

class ActivityTransform: TransformOf<CarePlanActivity, [String : AnyObject]> {

    init() {
        super.init(fromJSON: { (json) -> CarePlanActivity? in
            if let json = json {
                
            }
            return nil
            }, toJSON: { (activity) -> [String : AnyObject]? in
                if let _ = activity {
                    
                }
                return nil
        })
    }

}
