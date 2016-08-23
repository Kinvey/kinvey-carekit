//
//  CarePlanStore.swift
//  KinveyCareKit
//
//  Created by Victor Barros on 2016-08-08.
//  Copyright © 2016 Kinvey. All rights reserved.
//

import CareKit
import Kinvey

public class CarePlanStore: OCKCarePlanStore {
    
    let client: Client
    
    lazy var storeActivity: DataStore<CarePlanActivity> = {
        while (self.client.activeUser == nil) {
            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 1))
        }
        return DataStore<CarePlanActivity>.collection(.Network)
    }()
    
    lazy var storeEvent: DataStore<CarePlanEvent> = {
        while (self.client.activeUser == nil) {
            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 1))
        }
        return DataStore<CarePlanEvent>.collection(.Network)
    }()
    
    public init(persistenceDirectoryURL URL: NSURL, client: Client = sharedClient) {
        let client = Client.sharedClient.initialize(appKey: "kid_S1Bd9cy9", appSecret: "5b1770f12e8c4563ad9fc4cc502e7f04")
        
        if let _ = Client.sharedClient.activeUser {
            
        } else {
            User.login(username: "kinvey", password: "12345") { user, error in
                //   print (user)
            }
        }
        self.client = client
        self.client.logNetworkEnabled = true
        super.init(persistenceDirectoryURL: URL)
    }
    
    public override func addActivity(activity: OCKCarePlanActivity, completion: (Bool, NSError?) -> Void) {
        //network
        let kActivity = CarePlanActivity(activity)
        storeActivity.save(kActivity) { kActivity, error in
            if let _ = kActivity {
                //local
                super.addActivity(activity, completion: completion)
            } else if let error = error {
                completion(false, error as NSError)
            } else {
                completion(false, Error.InvalidResponse as NSError)
            }
        }
    }
    
    public override func activitiesWithCompletion(completion: (Bool, [OCKCarePlanActivity], NSError?) -> Void) {
        //super.activitiesWithCompletion(completion)      //return local data from CoreData
        
        storeActivity.find () { (kActivities, error) in
            var activities = [OCKCarePlanActivity]()
            if let _ = kActivities {
                for kActivity in kActivities! {
                    if let ockActivity = kActivity.ockCarePlanActivity {
                        activities.append(ockActivity)
                    }
                    
                }
                completion(true, activities, error as? NSError)
            }
            else {
                completion(false, activities, error as? NSError)
            }
            
        }
    }
    
    public override func activityForIdentifier(identifier: String, completion: (Bool, OCKCarePlanActivity?, NSError?) -> Void) {
        
        storeActivity.findById(identifier) { (kActivity, error) in
            if let ockActivity = kActivity?.ockCarePlanActivity {
                completion(true, ockActivity, error as? NSError)
            } else {
                completion(false, nil, error as? NSError)
            }
        }
    }

    
    public override func activitiesWithGroupIdentifier(groupIdentifier: String, completion: (Bool, [OCKCarePlanActivity], NSError?) -> Void) {
        
        storeActivity.find(Query(format: "groupIdentifier == %@", groupIdentifier)) { (kActivities, error) in
            var activities = [OCKCarePlanActivity]()
            if let _ = kActivities {
                for kActivity in kActivities! {
                    if let ockActivity = kActivity.ockCarePlanActivity {
                        activities.append(ockActivity)
                    }                    
                }
                completion(true, activities, error as? NSError)
            }
            else {
                completion(false, activities, error as? NSError)
            }            
        }
    }
    
    
    public override func activitiesWithType(type: OCKCarePlanActivityType, completion: (Bool, [OCKCarePlanActivity], NSError?) -> Void) {
        
        storeActivity.find(Query(format: "type == %@", type.rawValue)) { (kActivities, error) in
            var activities = [OCKCarePlanActivity]()
            if let _ = kActivities {
                for kActivity in kActivities! {
                    if let ockActivity = kActivity.ockCarePlanActivity {
                        activities.append(ockActivity)
                    }
                }
                completion(true, activities, error as? NSError)
            }
            else {
                completion(false, activities, error as? NSError)
            }
        }
        
        
    }
    
    
    
    public override func setEndDate(endDate: NSDateComponents, forActivity activity: OCKCarePlanActivity, completion: (Bool, OCKCarePlanActivity?, NSError?) -> Void){
        //TODO
    }
    
    public override func removeActivity(activity: OCKCarePlanActivity, completion: (Bool, NSError?) -> Void) {
        //TODO
    }
    

    public override func eventsForActivity(activity: OCKCarePlanActivity, date: NSDateComponents, completion: ([OCKCarePlanEvent], NSError?) -> Void) {
        super.eventsForActivity(activity, date: date, completion: completion)
//        
//        storeEvent.find(Query (format: "activityId == %@", activity.identifier)) { (kEvents, error) in
//            var events = [OCKCarePlanEvent]()
//            if let _ = kEvents {
//                for kEvent in kEvents! {
//                    if let ockEvent = kEvent as? OCKCarePlanEvent {     // WON't WORK
//                        events.append(ockEvent)
//                    }
//                }
//                completion(events, error as? NSError)
//            } else {
//                completion(events, error as? NSError)
//            }
//        }
//        
    }
    

    
    public override func updateEvent(event: OCKCarePlanEvent, withResult result: OCKCarePlanEventResult?, state: OCKCarePlanEventState, completion: (Bool, OCKCarePlanEvent?, NSError?) -> Void) {
        //network
        let kEvent = CarePlanEvent(event: event)
        storeEvent.save(kEvent) { kEvent, error in
            if let _ = kEvent {
                //local
                super.updateEvent(event, withResult: result, state: state, completion: completion)
                completion (true, event, error as? NSError)
            } else {
                completion (false, event, error as? NSError)
            }
            
        }
    }
    
    public override func
    
}
