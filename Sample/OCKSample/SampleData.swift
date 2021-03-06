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

import ResearchKit
import CareKit
import Kinvey
import KinveyCareKit
import PromiseKit

class SampleData: NSObject {

    // MARK: Properties

    /// An array of `Activity`s used in the app.
    let activities: [Activity] = [
        OutdoorWalk(),
        HamstringStretch(),
        TakeMedication(),
        BackPain(),
        Mood(),
        BloodGlucose(),
        Weight(),
        Caffeine()
    ]

    /**
     An `OCKPatient` object to assign contacts to.
     */
    var patient: OCKPatient!

    var kContacts: [Contact]? {
        didSet {
            _contacts = kContacts?.flatMap { $0.ockContact }
        }
    }

    private var _contacts: [OCKContact]?

    /**
        An array of `OCKContact`s to display on the Connect view.
    */
    var contacts: [OCKContact]!

    /**
     Connect message items
     */

    let dateString = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
    let replyDateString = DateFormatter.localizedString(from: Date().addingTimeInterval(1000), dateStyle: .short, timeStyle: .short)
    var connectMessageItems = [OCKConnectMessageItem]()
    var contactsWithMessageItems = [OCKContact]()

    // MARK: Initialization

    required init(carePlanStore: OCKCarePlanStore) {
        super.init()
        
//        for contact in contacts {
//            if contact.type == .careTeam {
//                self.contactsWithMessageItems.append(contact)
//                self.connectMessageItems = [OCKConnectMessageItem(messageType: OCKConnectMessageType.sent, name: self.patient.name, message: NSLocalizedString("I am feeling good after taking the medication! Thank you.", comment: ""), dateString: self.dateString), OCKConnectMessageItem(messageType: .received, name: contact.name, message: NSLocalizedString("That is great! Keep up the good work.", comment: ""), dateString: self.dateString)]
//                break
//            }
//        }
        
        // Populate the store with the sample activities.
        for sampleActivity in self.activities {
            let carePlanActivity = sampleActivity.carePlanActivity()
            
            carePlanStore.add(carePlanActivity) { success, error in
                if !success {
                    print(error!.localizedDescription)
                }
            }
        }
    }

    // MARK: Convenience

    /// Returns the `Activity` that matches the supplied `ActivityType`.
    func activityWithType(_ type: ActivityType) -> Activity? {
        for activity in activities where activity.activityType == type {
            return activity
        }

        return nil
    }

    func generateSampleDocument() -> OCKDocument {
        let subtitle = OCKDocumentElementSubtitle(subtitle: "First subtitle")

        let paragraph = OCKDocumentElementParagraph(content: "Lorem ipsum dolor sit amet, vim primis noster sententiae ne, et albucius apeirian accusata mea, vim at dicunt laoreet. Eu probo omnes inimicus ius, duo at veritus alienum. Nostrud facilisi id pro. Putant oporteat id eos. Admodum antiopam mel in, at per everti quaeque. Lorem ipsum dolor sit amet, vim primis noster sententiae ne, et albucius apeirian accusata mea, vim at dicunt laoreet. Eu probo omnes inimicus ius, duo at veritus alienum. Nostrud facilisi id pro. Putant oporteat id eos. Admodum antiopam mel in, at per everti quaeque. Lorem ipsum dolor sit amet, vim primis noster sententiae ne, et albucius apeirian accusata mea, vim at dicunt laoreet. Eu probo omnes inimicus ius, duo at veritus alienum. Nostrud facilisi id pro. Putant oporteat id eos. Admodum antiopam mel in, at per everti quaeque.")

        let document = OCKDocument(title: "Sample Document Title", elements: [subtitle, paragraph])
        document.pageHeader = "App Name: OCKSample, User Name: John Appleseed"

        return document
    }
}

