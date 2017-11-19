//
//  NSDateComponentsTransform.swift
//  KinveyCareKit
//
//  Created by Victor Barros on 2016-08-09.
//  Copyright © 2016 Kinvey. All rights reserved.
//

import Kinvey
import ObjectMapper

class NSDateComponentsTransform: TransformOf<DateComponents, [String : Any]> {
    
    init() {
        super.init(fromJSON: { (json) -> DateComponents? in
            if let json = json {
                var dateComponents = DateComponents()
                if let era = json["era"] as? Int {
                    dateComponents.era = era
                }
                if let year = json["year"] as? Int {
                    dateComponents.year = year
                }
                if let month = json["month"] as? Int {
                    dateComponents.month = month
                }
                if let day = json["day"] as? Int {
                    dateComponents.day = day
                }
                if let hour = json["hour"] as? Int {
                    dateComponents.hour = hour
                }
                if let minute = json["minute"] as? Int {
                    dateComponents.minute = minute
                }
                if let second = json["second"] as? Int {
                    dateComponents.second = second
                }
                if let nanosecond = json["nanosecond"] as? Int {
                    dateComponents.nanosecond = nanosecond
                }
                if let weekday = json["weekday"] as? Int {
                    dateComponents.weekday = weekday
                }
                if let weekdayOrdinal = json["weekdayOrdinal"] as? Int {
                    dateComponents.weekdayOrdinal = weekdayOrdinal
                }
                if let quarter = json["quarter"] as? Int {
                    dateComponents.quarter = quarter
                }
                if let weekOfMonth = json["weekOfMonth"] as? Int {
                    dateComponents.weekOfMonth = weekOfMonth
                }
                if let weekOfYear = json["weekOfYear"] as? Int {
                    dateComponents.weekOfYear = weekOfYear
                }
                if let yearForWeekOfYear = json["yearForWeekOfYear"] as? Int {
                    dateComponents.yearForWeekOfYear = yearForWeekOfYear
                }
                if let calendar = json["calendar"] as? Calendar {
                    dateComponents.calendar = calendar
                }
                if let timeZone = json["timeZone"] as? TimeZone {
                    dateComponents.timeZone = timeZone
                }
                return dateComponents
            }
            return nil
        }, toJSON: { (dateComponents) -> [String : Any]? in
            if let dateComponents = dateComponents {
                var json = [String : Any]()
                if let era = dateComponents.era {
                    json["era"] = era
                }
                if let year = dateComponents.year {
                    json["year"] = year
                }
                if let month = dateComponents.month {
                    json["month"] = month
                }
                if let day = dateComponents.day {
                    json["day"] = day
                }
                if let calendar = dateComponents.calendar {
                    json["calendar"] = calendar
                }
                return json
            }
            return nil
        })
    }
    
}
