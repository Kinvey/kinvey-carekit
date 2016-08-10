//
//  KinveyCareKitTests.swift
//  KinveyCareKitTests
//
//  Created by Victor Barros on 2016-08-09.
//  Copyright © 2016 Kinvey. All rights reserved.
//

import XCTest
import Kinvey
import CareKit
@testable import KinveyCareKit

class KinveyCareKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testActivitySerialization() {
        let activity = OutdoorWalk().carePlanActivity()
        let json = CarePlanActivity(OutdoorWalk().carePlanActivity()).toJSON()
        
//        XCTAssertEqual(json.count, expected.count)
        XCTAssertEqual(json[PersistableIdKey] as? String, activity.identifier)
        XCTAssertEqual(json["groupIdentifier"] as? String, activity.groupIdentifier)
        XCTAssertEqual(json["type"] as? Int, activity.type.rawValue)
        XCTAssertEqual(json["title"] as? String, activity.title)
        XCTAssertEqual(json["text"] as? String, activity.text)
        XCTAssertEqual(UIColorTransform().transformFromJSON(json["tintColor"] as? [String : CGFloat]), activity.tintColor)
        XCTAssertEqual(json["instructions"] as? String, activity.instructions)
        XCTAssertEqual(json["imageURL"] as? NSURL, activity.imageURL)
        let scheduleJson = json["schedule"] as? [String : AnyObject]
        XCTAssertNotNil(scheduleJson)
        if let scheduleJson = scheduleJson {
            XCTAssertEqual(CareSchedule(JSON: scheduleJson)!.ockCareSchedule, activity.schedule)
        }
        XCTAssertEqual(json["resultResettable"] as? Bool, activity.resultResettable)
//        XCTAssertEqual(json["userInfo"] as? [String : NSCoding], expected["userInfo"] as? [String : NSCoding])
    }
    
    func testStoreInKinvey() { 
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
