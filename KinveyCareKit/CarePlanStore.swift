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
        self.client = client
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
        
        client.logNetworkEnabled = true
        
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
        
        client.logNetworkEnabled = true
        
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
    
    
    public override func updateEvent(event: OCKCarePlanEvent, withResult result: OCKCarePlanEventResult?, state: OCKCarePlanEventState, completion: (Bool, OCKCarePlanEvent?, NSError?) -> Void) {
        //network
//        let kEvent = CarePlanEvent(event)
//        storeEvent.save(kEvent) { kEvent, error in
//            if let _ = kEvent {
//                //local
//                super.updateEvent(event, withResult: result, state: state, completion: completion)
//            } else if let error = error {
//                completion(false, error as NSError)
//            } else {
//                completion(false, Error.InvalidResponse as NSError)
//            }
//        }
    }
    
}
