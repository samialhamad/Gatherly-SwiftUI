//
//  ContactSyncManagerTests.swift
//  Gatherly-SwiftUITests
//
//  Created by Sami Alhamad on 5/2/25.
//

import XCTest
import Contacts
@testable import Gatherly_SwiftUI

final class ContactSyncManagerTests: XCTestCase {
    func testParseContacts_withValidContact_returnsSyncedContact() {
        let phone = CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: "(123) 456-7890"))
        let mockContact = CNMutableContact()
        mockContact.givenName = "Sami"
        mockContact.familyName = "Alhamad"
        mockContact.phoneNumbers = [phone]

        let parsed = ContactSyncManager.shared.parseContacts([mockContact])
        
        XCTAssertEqual(parsed.count, 1)
        XCTAssertEqual(parsed[0].fullName, "Sami Alhamad")
        XCTAssertEqual(parsed[0].phoneNumber, "1234567890")
    }

    func testParseContacts_withEmptyPhone_returnsEmpty() {
        let mockContact = CNMutableContact()
        mockContact.givenName = "Sami"
        mockContact.familyName = "Alhamad"
        mockContact.phoneNumbers = []

        let parsed = ContactSyncManager.shared.parseContacts([mockContact])
        
        XCTAssertTrue(parsed.isEmpty)
    }
}
