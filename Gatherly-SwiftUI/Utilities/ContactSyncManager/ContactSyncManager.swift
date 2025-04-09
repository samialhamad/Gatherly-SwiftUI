//
//  ContactSyncManager.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/7/25.
//

import Contacts

// Represents a single contact from the device's address book
struct SyncedContact: Hashable, Equatable {
    let fullName: String
    let phoneNumber: String
}

class ContactSyncManager {
    static let shared = ContactSyncManager()
    private init() {}

    func fetchContactsPhoneNumbers(completion: @escaping (Set<String>) -> Void) {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, _ in
            guard granted else {
                completion([])
                return
            }

            let keys = [CNContactPhoneNumbersKey] as [CNKeyDescriptor]
            let request = CNContactFetchRequest(keysToFetch: keys)
            var phoneNumbers = Set<String>()

            do {
                try store.enumerateContacts(with: request) { contact, _ in
                    for number in contact.phoneNumbers {
                        let raw = number.value.stringValue
                        let digits = raw.filter(\.isWholeNumber)
                        if !digits.isEmpty {
                            phoneNumbers.insert(digits)
                        }
                    }
                }
                DispatchQueue.main.async {
                    completion(phoneNumbers)
                }
            } catch {
                print("Failed to fetch contacts:", error)
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
}
