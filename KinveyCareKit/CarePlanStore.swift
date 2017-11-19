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
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        }
        return DataStore<CarePlanActivity>.collection(.network)
    }()
    
    lazy var storeEvent: DataStore<CarePlanEvent> = {
        while (self.client.activeUser == nil) {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        }
        return DataStore<CarePlanEvent>.collection(.network)
    }()
    
    public init(persistenceDirectoryURL URL: URL, client: Client = sharedClient) {
        let client = Client.sharedClient
        client.initialize(appKey: "kid_S1Bd9cy9", appSecret: "5b1770f12e8c4563ad9fc4cc502e7f04")
        
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
    
    public override func add(_ activity: OCKCarePlanActivity, completion: @escaping (Bool, Swift.Error?) -> Void) {
        //network
        let kActivity = CarePlanActivity(activity)
        storeActivity.save(kActivity) { kActivity, error in
            if let _ = kActivity {
                //local
                super.add(activity, completion: completion)
            } else if let error = error {
                completion(false, error)
            } else {
                completion(false, Kinvey.Error.invalidResponse(httpResponse: nil, data: nil))
            }
        }
    }
    
    public override func activities(completion: @escaping (Bool, [OCKCarePlanActivity], Swift.Error?) -> Void) {
        //super.activities(completion: completion)      //return local data from CoreData
        
        storeActivity.find () { (kActivities, error) in
            var activities = [OCKCarePlanActivity]()
            if let _ = kActivities {
                for kActivity in kActivities! {
                    if let ockActivity = kActivity.ockCarePlanActivity {
                        activities.append(ockActivity)
                    }
                    
                }
                completion(true, activities, error)
            }
            else {
                completion(false, activities, error)
            }
            
        }
    }
    
    public override func activity(forIdentifier identifier: String, completion: @escaping (Bool, OCKCarePlanActivity?, Swift.Error?) -> Void) {
        storeActivity.find(identifier) { (kActivity, error) in
            if let ockActivity = kActivity?.ockCarePlanActivity {
                completion(true, ockActivity, error as? NSError)
            } else {
                completion(false, nil, error as? NSError)
            }
        }
    }
    
    public override func activities(withGroupIdentifier groupIdentifier: String, completion: @escaping (Bool, [OCKCarePlanActivity], Swift.Error?) -> Void) {
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
    
    public override func activities(with type: OCKCarePlanActivityType, completion: @escaping (Bool, [OCKCarePlanActivity], Swift.Error?) -> Void) {
        storeActivity.find(Query(format: "type == %@", type.rawValue)) { (kActivities, error) in
            var activities = [OCKCarePlanActivity]()
            if let _ = kActivities {
                for kActivity in kActivities! {
                    if let ockActivity = kActivity.ockCarePlanActivity {
                        activities.append(ockActivity)
                    }
                }
                completion(true, activities, error)
            }
            else {
                completion(false, activities, error)
            }
        }
        
        
    }
    
    public override func setEndDate(_ endDate: DateComponents, for activity: OCKCarePlanActivity, completion: @escaping (Bool, OCKCarePlanActivity?, Swift.Error?) -> Void) {
        //TODO
    }
    
    public override func remove(_ activity: OCKCarePlanActivity, completion: @escaping (Bool, Swift.Error?) -> Void) {
        //TODO
    }
    
    public override func events(for activity: OCKCarePlanActivity, date: DateComponents, completion: @escaping ([OCKCarePlanEvent], Swift.Error?) -> Void) {
        super.events(for: activity, date: date, completion: completion)
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
    
    public override func update(_ event: OCKCarePlanEvent, with result: OCKCarePlanEventResult?, state: OCKCarePlanEventState, completion: @escaping (Bool, OCKCarePlanEvent?, Swift.Error?) -> Void) {
        //network
        let kEvent = CarePlanEvent(event: event)
        storeEvent.save(kEvent) { kEvent, error in
            if let _ = kEvent {
                //local
                super.update(event, with: result, state: state, completion: completion)
                completion (true, event, error)
            } else {
                completion (false, event, error)
            }
            
        }
    }
    
}
