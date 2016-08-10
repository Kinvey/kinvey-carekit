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
        return DataStore<CarePlanActivity>.collection(.Network, client: self.client)
    }()
    
    lazy var storeEvent: DataStore<CarePlanEvent> = {
        while (self.client.activeUser == nil) {
            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 1))
        }
        return DataStore<CarePlanEvent>.collection(.Network, client: self.client)
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
    
    public override func updateEvent(event: OCKCarePlanEvent, withResult result: OCKCarePlanEventResult?, state: OCKCarePlanEventState, completion: (Bool, OCKCarePlanEvent?, NSError?) -> Void) {
        //network
        let kEvent = CarePlanEvent(event)
        storeEvent.save(kEvent) { kEvent, error in
            if let _ = kEvent {
                //local
                super.updateEvent(event, withResult: result, state: state, completion: completion)
            } else if let error = error {
                completion(false, error as NSError)
            } else {
                completion(false, Error.InvalidResponse as NSError)
            }
        }
    }
    
}