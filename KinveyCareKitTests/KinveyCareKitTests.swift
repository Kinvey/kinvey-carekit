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
        
        weak var expectationInitialize = expectation(description: "Kinvey Initialize")
        
        Kinvey.sharedClient.initialize(appKey: "kid_S1Bd9cy9", appSecret: "5b1770f12e8c4563ad9fc4cc502e7f04") {
            switch $0 {
            case .success(_):
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectationInitialize?.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (error) in
            expectationInitialize = nil
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testActivitySerialization() {
        let activity = OutdoorWalk().carePlanActivity()
        let json = CarePlanActivity(OutdoorWalk().carePlanActivity()).toJSON()
        
//        XCTAssertEqual(json.count, expected.count)
        XCTAssertEqual(json[Entity.Key.entityId] as? String, activity.identifier)
        XCTAssertEqual(json["groupIdentifier"] as? String, activity.groupIdentifier)
        XCTAssertEqual(json["type"] as? Int, activity.type.rawValue)
        XCTAssertEqual(json["title"] as? String, activity.title)
        XCTAssertEqual(json["text"] as? String, activity.text)
        XCTAssertEqual(UIColorTransform().transformFromJSON(json["tintColor"] as? [String : CGFloat]), activity.tintColor)
        XCTAssertEqual(json["instructions"] as? String, activity.instructions)
        XCTAssertEqual(json["imageURL"] as? URL, activity.imageURL)
        let scheduleJson = json["schedule"] as? [String : Any]
        XCTAssertNotNil(scheduleJson)
        if let scheduleJson = scheduleJson {
            let careSchedule = CareSchedule(JSON: scheduleJson)
            XCTAssertEqual(careSchedule?.ockCareSchedule, activity.schedule)
        }
        XCTAssertEqual(json["resultResettable"] as? Bool, activity.resultResettable)
//        XCTAssertEqual(json["userInfo"] as? [String : NSCoding], expected["userInfo"] as? [String : NSCoding])
    }
    
    func testStoreInKinvey() {
        
        weak var expectationLogin = expectation(description: "Login")
        if let _ = Client.sharedClient.activeUser {
            expectationLogin?.fulfill()
        }
        else {
            User.login(username: "kinvey", password: "12345") { user, error in
                expectationLogin?.fulfill()
            }

        }

        waitForExpectations(timeout: 30) { (error) in
            expectationLogin = nil
        }

        weak var expectationSave = expectation(description: "Save")
        
        let searchPaths = NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true)
        let applicationSupportPath = searchPaths[0]
        let persistenceDirectoryURL = URL(fileURLWithPath: applicationSupportPath)

        let cpStore = CarePlanStore(persistenceDirectoryURL: persistenceDirectoryURL)
        
        cpStore.add(OutdoorWalk().carePlanActivity()) { (success, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            expectationSave?.fulfill()
        }
        
        
//        let store:DataStore<CarePlanActivity> = DataStore<CarePlanActivity>.collection(.network)
//        store.save(CarePlanActivity(OutdoorWalk().carePlanActivity()), completionHandler: { (activity, error) in
//            //complete
//            print(activity)
//            expectationSave?.fulfill()
//        })
        
        waitForExpectations(timeout: 30) { (error) in
            expectationSave = nil
        }

        
        weak var expectationFind = expectation(description: "Find")
        //cpStore.activitiesWithCompletion { (success, activities, error) in
        cpStore.activities(with: OCKCarePlanActivityType.intervention) { (success, activities, error) in
            if let error = error {
                print(error)
            } else {
                print (activities)
            }
            
            expectationFind?.fulfill()
        }
        
        waitForExpectations(timeout: 30) { (error) in
            expectationFind = nil
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
