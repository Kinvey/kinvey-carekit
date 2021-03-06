/*
 Copyright (c) 2017, Apple Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 1.  Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2.  Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation and/or
 other materials provided with the distribution.
 
 3.  Neither the name of the copyright holder(s) nor the names of any contributors
 may be used to endorse or promote products derived from this software without
 specific prior written permission. No license is granted to the trademarks of
 the copyright holders even if such marks are included in this software.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import CareKit
import ResearchKit
import WatchConnectivity
import Kinvey
import KinveyCareKit
import PromiseKit

class RootViewController: UITabBarController {
    // MARK: Properties
    
    fileprivate let sampleData: SampleData
    
    fileprivate let storeManager = CarePlanStoreManager.sharedCarePlanStoreManager
    
    fileprivate var careContentsViewController: OCKCareContentsViewController!
    
    fileprivate var insightsViewController: OCKInsightsViewController!
    
    fileprivate var connectViewController: OCKConnectViewController!
    
    fileprivate var watchManager: WatchConnectivityManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoutBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logout(_:)))
        navigationItem.leftBarButtonItem = logoutBarButtonItem
    }
    
    @objc
    func logout(_ sender: Any?) {
        if let user = Kinvey.sharedClient.activeUser {
            user.logout()
            performSegue(withIdentifier: "logout", sender: sender)
        }
    }
    
    // MARK: Initialization
    
    required init?(coder aDecoder: NSCoder) {
        sampleData = SampleData(carePlanStore: storeManager.store)
        
        super.init(coder: aDecoder)
        
        careContentsViewController = createCareContentsViewController()
        insightsViewController = createInsightsViewController()
        connectViewController = createConnectViewController()
        
        self.viewControllers = [
            UINavigationController(rootViewController: careContentsViewController),
            UINavigationController(rootViewController: insightsViewController),
            UINavigationController(rootViewController: connectViewController)
        ]
        
        storeManager.delegate = self
        watchManager = WatchConnectivityManager(withStore: storeManager.store)
        let glyphType = Glyph.glyphType(rawValue: careContentsViewController.glyphType.rawValue)
        
        // Default the default glyph tint color
        
        var glyphTintColor = OCKGlyph.defaultColor(for: careContentsViewController.glyphType)
        if (careContentsViewController.glyphTintColor != nil) {
            glyphTintColor = careContentsViewController.glyphTintColor
        }
        
        // Create color component array
        let glyphTintColorComponents = glyphTintColor.cgColor.components
        let glyphTintColorArray = [glyphTintColorComponents![0], glyphTintColorComponents![1], glyphTintColorComponents![2], glyphTintColorComponents![3]]
        watchManager?.glyphType = Glyph.imageNameForGlyphType(glyphType: glyphType!)
        watchManager?.glyphTintColor = glyphTintColorArray
        
        // Set the custom image name if the glyphType is custom
        if (careContentsViewController.glyphType == .custom) {
            let glyphImageName = careContentsViewController.customGlyphImageName
            if (glyphImageName != "") {
                watchManager?.glyphImageName = glyphImageName
            }
            
            watchManager?.sendGlyphType(glyphType: Glyph.imageNameForGlyphType(glyphType: glyphType!),
                                        glyphTintColor: glyphTintColorArray,
                                        glyphImageName: glyphImageName)
        } else {
            watchManager?.sendGlyphType(glyphType: Glyph.imageNameForGlyphType(glyphType: glyphType!), glyphTintColor: glyphTintColorArray)
        }
    }
    
    // MARK: Convenience
    
    fileprivate func createInsightsViewController() -> OCKInsightsViewController {
        // Create an `OCKInsightsViewController` with sample data.
        let activityType1: ActivityType = .backPain
        let activityType2: ActivityType = .bloodGlucose
        let activityType3: ActivityType = .weight
        let widget1 = OCKPatientWidget.defaultWidget(withActivityIdentifier: activityType1.rawValue, tintColor: OCKColor.red)
        let widget2 = OCKPatientWidget.defaultWidget(withActivityIdentifier: activityType2.rawValue, tintColor: OCKColor.red)
        let widget3 = OCKPatientWidget.defaultWidget(withActivityIdentifier: activityType3.rawValue, tintColor: OCKColor.red)
        
        let viewController = OCKInsightsViewController(insightItems: storeManager.insights, patientWidgets: [widget1, widget2, widget3], thresholds: [activityType1.rawValue], store:storeManager.store)
        
        // Setup the controller's title and tab bar item
        viewController.title = NSLocalizedString("Insights", comment: "")
        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named:"insights"), selectedImage: UIImage(named: "insights-filled"))
        
        return viewController    }
    
    fileprivate func createCareContentsViewController() -> OCKCareContentsViewController {
        let viewController = OCKCareContentsViewController(carePlanStore: storeManager.store)
        viewController.title = NSLocalizedString("Care Contents", comment: "")
        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named:"carecard"), selectedImage: UIImage(named: "carecard-filled"))
        viewController.delegate = self;
        return viewController

    }
    
    lazy var contactDataStore = DataStore<Contact>.collection(.network)
    
    func loadContacts() -> Promise<[Contact]> {
        return Promise<AnyRandomAccessCollection<Contact>> { fulfill, reject in
            self.contactDataStore.find(options: nil) { (result: Kinvey.Result<AnyRandomAccessCollection<Contact>, Swift.Error>) in
                switch result {
                case .success(let contacts):
                    if contacts.count > 0 {
                        fulfill(contacts)
                    } else {
                        let ockContacts = [
                            OCKContact(contactType: .careTeam,
                                       name: "Dr. Maria Ruiz",
                                       relation: "Physician",
                                       contactInfoItems: [OCKContactInfo.phone("888-555-5512"), OCKContactInfo.sms("888-555-5512"), OCKContactInfo.email("mruiz2@mac.com")],
                                       tintColor: Colors.blue.color,
                                       monogram: "MR",
                                       image: nil),
                            
                            OCKContact(contactType: .careTeam,
                                       name: "Bill James",
                                       relation: "Nurse",
                                       contactInfoItems: [OCKContactInfo.phone("888-555-5512"), OCKContactInfo.sms("888-555-5512"), OCKContactInfo.email("billjames2@mac.com")],
                                       tintColor: Colors.green.color,
                                       monogram: "BJ",
                                       image: nil),
                            
                            OCKContact(contactType: .personal,
                                       name: "Tom Clark",
                                       relation: "Father",
                                       contactInfoItems: [OCKContactInfo.phone("888-555-5512"), OCKContactInfo.sms("888-555-5512")],
                                       tintColor: Colors.yellow.color,
                                       monogram: "TC",
                                       image: nil)
                            ].map { Contact($0) }
                        var promises = [Promise<Contact>]()
                        for ockContact in ockContacts {
                            promises.append(Promise<Contact> { fulfill, reject in
                                self.contactDataStore.save(ockContact, options: nil) {
                                    switch $0 {
                                    case .success(let contact):
                                        fulfill(contact)
                                    case .failure(let error):
                                        reject(error)
                                    }
                                }
                            })
                        }
                        when(fulfilled: promises).then {
                            fulfill(AnyRandomAccessCollection($0))
                        }
                    }
                case .failure(let error):
                    reject(error)
                }
            }
        }.then { contacts in
            return Array(contacts)
        }
    }
    
    lazy var patientDataStore = DataStore<Patient>.collection(.network)
    
    func loadPatient() -> Promise<OCKPatient> {
        return Promise<AnyRandomAccessCollection<Patient>> { fulfill, reject in
            let query = Query(format: "user._id == %@", Kinvey.sharedClient.activeUser!.userId)
            self.patientDataStore.find(query, options: nil) { (result: Kinvey.Result<AnyRandomAccessCollection<Patient>, Swift.Error>) in
                switch result {
                case .success(let patients):
                    fulfill(patients)
                case .failure(let error):
                    reject(error)
                }
            }
        }.then { patients in
            return Promise<Patient> { fulfill, reject in
                if let patient = patients.first {
                    fulfill(patient)
                } else {
                    self.loadContacts().then { (contacts) -> Void in
                        let patient = OCKPatient(identifier: "patient", carePlanStore: self.storeManager.store, name: "John Doe", detailInfo: nil, careTeamContacts: contacts.flatMap({ $0.ockContact }), tintColor: Colors.lightBlue.color, monogram: "JD", image: nil, categories: nil, userInfo: ["Age": "21", "Gender": "M", "Phone":"888-555-5512"])
                        
                        let kPatient = Patient(patient, careTeamContacts: contacts, user: Kinvey.sharedClient.activeUser!)
                        self.patientDataStore.save(kPatient, options: nil) {
                            switch $0 {
                            case .success(let patient):
                                fulfill(patient)
                            case .failure(let error):
                                reject(error)
                            }
                        }
                    }.catch {
                        reject($0)
                    }
                }
            }
        }.then {
            return OCKPatient($0, carePlanStore: self.storeManager.store)!
        }
    }
    
    lazy var documentDataStore = DataStore<Document>.collection(.network)
    
    func loadDocument() -> Promise<Document> {
        return Promise<Document> { fulfill, reject in
            self.documentDataStore.find("report", options: nil) {
                switch $0 {
                case .success(let document):
                    fulfill(document)
                case .failure(let error):
                    if let error = error as? Kinvey.Error {
                        switch error {
                        case .unknownJsonError(let httpResponse, _, _):
                            if httpResponse?.statusCode == 404 {
                                let image = OCKDocumentElementImage(image: UIImage(named: "AppIcon")!)
                                
                                let subtitle = OCKDocumentElementSubtitle(subtitle: "First subtitle")
                                
                                let paragraph = OCKDocumentElementParagraph(content: "Lorem ipsum dolor sit amet, vim primis noster sententiae ne, et albucius apeirian accusata mea, vim at dicunt laoreet. Eu probo omnes inimicus ius, duo at veritus alienum. Nostrud facilisi id pro. Putant oporteat id eos. Admodum antiopam mel in, at per everti quaeque. Lorem ipsum dolor sit amet, vim primis noster sententiae ne, et albucius apeirian accusata mea, vim at dicunt laoreet. Eu probo omnes inimicus ius, duo at veritus alienum. Nostrud facilisi id pro. Putant oporteat id eos. Admodum antiopam mel in, at per everti quaeque. Lorem ipsum dolor sit amet, vim primis noster sententiae ne, et albucius apeirian accusata mea, vim at dicunt laoreet. Eu probo omnes inimicus ius, duo at veritus alienum. Nostrud facilisi id pro. Putant oporteat id eos. Admodum antiopam mel in, at per everti quaeque.")
                                
                                let table = OCKDocumentElementTable(headers: ["1st Column", "2nd Column"], rows: [["A1", "B1"], ["A2", "B2"]])
                                
                                let chart1Series1 = OCKBarSeries.init(title: "Chart #1 Series #1", values: [20,04,60,40], valueLabels: ["20","04","60","40"], tintColor: UIColor.cyan)
                                let chart1Series2 = OCKBarSeries.init(title: "Chart #1 Series #2", values: [5,15,35,16], valueLabels: ["5","15","35","16"], tintColor: UIColor.magenta)
                                let chart1 = OCKBarChart.init(title: "Chart #1", text: "Chart #1 Description", tintColor: UIColor.gray, axisTitles: ["ABC","DEF","GHI","JKL"], axisSubtitles: ["123","456","789","012"], dataSeries: [chart1Series1, chart1Series2])
                                
                                let chart = OCKDocumentElementChart(chart: chart1)
                                
                                let document = OCKDocument(title: "Sample Document Title", elements: [image, subtitle, paragraph, table, chart])
                                document.pageHeader = "App Name: OCKSample, User Name: John Appleseed"
                                
                                let kDocument = Document(document)
                                kDocument.entityId = "report"
                                self.documentDataStore.save(kDocument, options: nil) {
                                    switch $0 {
                                    case .success(let document):
                                        fulfill(document)
                                    case .failure(let error):
                                        reject(error)
                                    }
                                }
                            } else {
                                reject(error)
                            }
                        default:
                            reject(error)
                        }
                    } else {
                        reject(error)
                    }
                }
            }
        }
    }

    fileprivate func createConnectViewController() -> OCKConnectViewController {
        let viewController = OCKConnectViewController.init(contacts: nil, patient: nil)
        viewController.delegate = self
        viewController.dataSource = self
        // Setup the controller's title and tab bar item
        viewController.title = NSLocalizedString("Connect", comment: "")
        viewController.tabBarItem = UITabBarItem(title: viewController.title, image: UIImage(named:"connect"), selectedImage: UIImage(named: "connect-filled"))
        
        loadContacts().then { (contacts) -> Promise<OCKPatient> in
            viewController.contacts = contacts.flatMap { $0.ockContact }
            return self.loadPatient()
        }.then {
            viewController.patient = $0
        }
        
        return viewController
    }
}


extension RootViewController: OCKCareContentsViewControllerDelegate {
    
    func careContentsViewController(_ viewController: OCKCareContentsViewController, didSelectRowWithAssessmentEvent assessmentEvent: OCKCarePlanEvent) {
            // Lookup the assessment the row represents.
            guard let activityType = ActivityType(rawValue: assessmentEvent.activity.identifier) else { return }
            guard let sampleAssessment = sampleData.activityWithType(activityType) as? Assessment else { return }
            
            /*
             Check if we should show a task for the selected assessment event
             based on its state.
             */
            guard assessmentEvent.state == .initial ||
                assessmentEvent.state == .notCompleted ||
                (assessmentEvent.state == .completed && assessmentEvent.activity.resultResettable) else { return }
            
            // Show an `ORKTaskViewController` for the assessment's task.
            let taskViewController = ORKTaskViewController(task: sampleAssessment.task(), taskRun: nil)
            taskViewController.delegate = self
            
            present(taskViewController, animated: true, completion: nil)
    }
}

extension RootViewController: ORKTaskViewControllerDelegate {
    
    /// Called with then user completes a presented `ORKTaskViewController`.
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Swift.Error?) {
        defer {
            dismiss(animated: true, completion: nil)
        }
        
        // Make sure the reason the task controller finished is that it was completed.
        guard reason == .completed else { return }
        
        // Determine the event that was completed and the `SampleAssessment` it represents.
        guard let event = careContentsViewController.lastSelectedEvent,
            let activityType = ActivityType(rawValue: event.activity.identifier),
            let sampleAssessment = sampleData.activityWithType(activityType) as? Assessment else { return }
        
        // Build an `OCKCarePlanEventResult` that can be saved into the `OCKCarePlanStore`.
        let carePlanResult = sampleAssessment.buildResultForCarePlanEvent(event, taskResult: taskViewController.result)
        
        // Check assessment can be associated with a HealthKit sample.
        if let healthSampleBuilder = sampleAssessment as? HealthSampleBuilder {
            // Build the sample to save in the HealthKit store.
            let sample = healthSampleBuilder.buildSampleWithTaskResult(taskViewController.result)
            let sampleTypes: Set<HKSampleType> = [sample.sampleType]
            
            // Requst authorization to store the HealthKit sample.
            let healthStore = HKHealthStore()
            healthStore.requestAuthorization(toShare: sampleTypes, read: sampleTypes, completion: { success, _ in
                // Check if authorization was granted.
                if !success {
                    /*
                        Fall back to saving the simple `OCKCarePlanEventResult`
                        in the `OCKCarePlanStore`.
                    */
                    self.completeEvent(event, inStore: self.storeManager.store, withResult: carePlanResult)
                    return
                }
                
                // Save the HealthKit sample in the HealthKit store.
                healthStore.save(sample, withCompletion: { success, _ in
                    if success {
                        /*
                            The sample was saved to the HealthKit store. Use it
                            to create an `OCKCarePlanEventResult` and save that
                            to the `OCKCarePlanStore`.
                         */
                        let healthKitAssociatedResult = OCKCarePlanEventResult(
                                quantitySample: sample,
                                quantityStringFormatter: nil,
                                display: healthSampleBuilder.unit,
                                displayUnitStringKey: healthSampleBuilder.localizedUnitForSample(sample),
                                userInfo: nil
                        )
                        
                        self.completeEvent(event, inStore: self.storeManager.store, withResult: healthKitAssociatedResult)
                    }
                    else {
                        /*
                            Fall back to saving the simple `OCKCarePlanEventResult`
                            in the `OCKCarePlanStore`.
                        */
                        self.completeEvent(event, inStore: self.storeManager.store, withResult: carePlanResult)
                    }
                    
                })
            })
        }
        else {
            // Update the event with the result.
            completeEvent(event, inStore: storeManager.store, withResult: carePlanResult)
        }
    }
    
    // MARK: Convenience
    
    fileprivate func completeEvent(_ event: OCKCarePlanEvent, inStore store: OCKCarePlanStore, withResult result: OCKCarePlanEventResult) {
        store.update(event, with: result, state: .completed) { success, _, error in
            if !success {
                print(error!.localizedDescription)
            }
        }
    }
}

// MARK: OCKConnectViewControllerDataSource

extension RootViewController: OCKConnectViewControllerDataSource {
    
    func connectViewControllerNumber(ofConnectMessageItems viewController: OCKConnectViewController, careTeamContact contact: OCKContact) -> Int {
        return sampleData.connectMessageItems.count
    }
    
    func connectViewControllerCareTeamConnections(_ viewController: OCKConnectViewController) -> [OCKContact] {
        return sampleData.contactsWithMessageItems
    }
    
    func connectViewController(_ viewController: OCKConnectViewController, connectMessageItemAt index: Int, careTeamContact contact: OCKContact) -> OCKConnectMessageItem {
        return sampleData.connectMessageItems[index]
    }
}

// MARK: OCKConnectViewControllerDelegate

extension RootViewController: OCKConnectViewControllerDelegate {
    
    /// Called when the user taps a contact in the `OCKConnectViewController`.
    func connectViewController(_ connectViewController: OCKConnectViewController, didSelectShareButtonFor contact: OCKContact, presentationSourceView sourceView: UIView?) {
        loadDocument().then { (document) -> Void in
            OCKDocument(document).createPDFData {(data, error) in
                let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                DispatchQueue.main.async {
                    self.present(activityViewController, animated: true, completion: nil)
                }
            }
        }
        
        func connectViewController(_ viewController: OCKConnectViewController, didSendConnectMessage message: String, careTeamContact contact: OCKContact) {
            loadPatient().then { (patient) -> Void in
                let dateString = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
                let connectMessage = OCKConnectMessageItem(messageType: .sent, name: patient.name, message: message, dateString: dateString)
                self.sampleData.connectMessageItems.append(connectMessage)
            }
        }
    }
    
    func connectViewController(_ viewController: OCKConnectViewController, didSendConnectMessage message: String, careTeamContact contact: OCKContact) {
        loadPatient().then { (patient) -> Void in
            let dateString = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
            let connectMessage = OCKConnectMessageItem(messageType: .sent, name: patient.name, message: message, dateString: dateString)
            self.sampleData.connectMessageItems.append(connectMessage)
        }
    }
}


// MARK: CarePlanStoreManagerDelegate

extension RootViewController: CarePlanStoreManagerDelegate {
    
    /// Called when the `CarePlanStoreManager`'s insights are updated.
    func carePlanStoreManager(_ manager: CarePlanStoreManager, didUpdateInsights insights: [OCKInsightItem]) {
        // Update the insights view controller with the new insights.
        insightsViewController.items = insights
    }
}
