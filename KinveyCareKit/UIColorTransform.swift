//
//  UIColorTransform.swift
//  KinveyCareKit
//
//  Created by Victor Barros on 2016-08-09.
//  Copyright © 2016 Kinvey. All rights reserved.
//

import Kinvey
import ObjectMapper

class UIColorTransform: TransformOf<UIColor, [String : CGFloat]> {
    
    init() {
        super.init(fromJSON: { (json) -> UIColor? in
            if let json = json {
                if let red = json["r"],
                    let green = json["g"],
                    let blue = json["b"],
                    let alpha = json["a"]
                {
                    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
                }
            }
            return nil
        }, toJSON: { (color) -> [String : CGFloat]? in
            if let color = color {
                var red: CGFloat = 0
                var green: CGFloat = 0
                var blue: CGFloat = 0
                var alpha: CGFloat = 0
                if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
                    return [
                        "r" : red,
                        "g" : green,
                        "b" : blue,
                        "a" : alpha
                    ]
                }
            }
            return nil
        })
    }
    
}
