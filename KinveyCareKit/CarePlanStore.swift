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
        waitForActiveUser()
        return DataStore<CarePlanActivity>.collection(.network)
    }()
    
    lazy var storeEvent: DataStore<CarePlanEvent> = {
        waitForActiveUser()
        return DataStore<CarePlanEvent>.collection(.network)
    }()
    
    public init(persistenceDirectoryURL URL: URL, client: Client = sharedClient) {
        self.client = client
        self.client.logNetworkEnabled = true
        super.init(persistenceDirectoryURL: URL)
    }
    
    private func waitForActiveUser() {
        guard client.activeUser == nil else {
            return
        }
        
        let observer = CFRunLoopObserverCreateWithHandler(nil, CFRunLoopActivity.beforeWaiting.rawValue, true, 0) { observer, activity in
            if self.client.activeUser != nil {
                CFRunLoopStop(CFRunLoopGetCurrent())
            } else {
                CFRunLoopWakeUp(CFRunLoopGetCurrent())
            }
        }
        
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, CFRunLoopMode.defaultMode)
        CFRunLoopRunInMode(CFRunLoopMode.defaultMode, CFTimeInterval.infinity, false)
        CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), observer, CFRunLoopMode.defaultMode)
    }
    
    public override func add(_ activity: OCKCarePlanActivity, completion: @escaping (Bool, Swift.Error?) -> Void) {
        //network
        let kActivity = CarePlanActivity(activity)
        storeActivity.save(kActivity, options: nil) {
            switch $0 {
            case .success(_):
                super.add(activity, completion: completion)
            case .failure(let error):
                completion(false, error)
            }
        }
    }
    
    public override func activities(completion: @escaping (Bool, [OCKCarePlanActivity], Swift.Error?) -> Void) {
        //super.activities(completion: completion)      //return local data from CoreData
        
        storeActivity.find(options: nil) { (result: Result<AnyRandomAccessCollection<CarePlanActivity>, Swift.Error>) in
            var activities = [OCKCarePlanActivity]()
            switch result {
            case .success(let kActivities):
                for kActivity in kActivities {
                    if let ockActivity = kActivity.ockCarePlanActivity {
                        activities.append(ockActivity)
                    }
                }
                completion(true, activities, nil)
            case .failure(let error):
                completion(false, activities, error)
            }
        }
    }
    
    public override func activity(forIdentifier identifier: String, completion: @escaping (Bool, OCKCarePlanActivity?, Swift.Error?) -> Void) {
        storeActivity.find(identifier, options: nil) {
            switch $0 {
            case .success(let kActivity):
                completion(true, kActivity.ockCarePlanActivity, nil)
            case .failure(let error):
                completion(false, nil, error)
            }
        }
    }
    
    public override func activities(withGroupIdentifier groupIdentifier: String, completion: @escaping (Bool, [OCKCarePlanActivity], Swift.Error?) -> Void) {
        storeActivity.find(Query(format: "groupIdentifier == %@", groupIdentifier), options: nil) { (result: Result<AnyRandomAccessCollection<CarePlanActivity>, Swift.Error>) in
            var activities = [OCKCarePlanActivity]()
            switch result {
            case .success(let kActivities):
                for kActivity in kActivities {
                    if let ockActivity = kActivity.ockCarePlanActivity {
                        activities.append(ockActivity)
                    }
                }
                completion(true, activities, nil)
            case .failure(let error):
                completion(false, activities, error)
            }
        }
    }
    
    public override func activities(with type: OCKCarePlanActivityType, completion: @escaping (Bool, [OCKCarePlanActivity], Swift.Error?) -> Void) {
        storeActivity.find(Query(format: "type == %@", type.rawValue), options: nil) { (result: Result<AnyRandomAccessCollection<CarePlanActivity>, Swift.Error>) in
            var activities = [OCKCarePlanActivity]()
            switch result {
            case .success(let kActivities):
                for kActivity in kActivities {
                    if let ockActivity = kActivity.ockCarePlanActivity {
                        activities.append(ockActivity)
                    }
                }
                completion(true, activities, nil)
            case .failure(let error):
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
        
        //TODO
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
        storeEvent.save(kEvent, options: nil) {
            switch $0 {
            case .success(_):
                super.update(event, with: result, state: state, completion: completion)
            case .failure(let error):
                completion (false, event, error)
            }
        }
    }
    
}
