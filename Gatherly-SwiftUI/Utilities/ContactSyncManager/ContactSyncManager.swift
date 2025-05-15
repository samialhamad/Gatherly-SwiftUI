//
//  ContactSyncManager.swift
//  Gatherly-SwiftUI
//
//  Created by Sami Alhamad on 4/7/25.
//

import Contacts

struct SyncedContact: Hashable, Equatable {
    let fullName: String
    let phoneNumber: String
}

class ContactSyncManager {
    static let shared = ContactSyncManager()
    private init() {}
    
    func fetchContacts(completion: @escaping ([SyncedContact]) -> Void) {
        let store = CNContactStore()

        store.requestAccess(for: .contacts) { granted, _ in
            guard granted else {
                completion([])
                return
            }
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self else {
                    completion([])
                    return
                }
                
                let keys: [CNKeyDescriptor] = [
                    CNContactGivenNameKey as CNKeyDescriptor, // first name
                    CNContactFamilyNameKey as CNKeyDescriptor, // last name
                    CNContactPhoneNumbersKey as CNKeyDescriptor
                ]

                let request = CNContactFetchRequest(keysToFetch: keys)
                var contacts: [CNContact] = []

                do {
                    try store.enumerateContacts(with: request) { contact, _ in
                        contacts.append(contact)
                    }
                    
                    let results = self.parseContacts(contacts)
                    completion(results)
                } catch {
                    print("Failed to fetch contacts:", error)
                    completion([])
                }
            }
        }
    }
    
    func parseContacts(_ contacts: [CNContact]) -> [SyncedContact] {
        var results: [SyncedContact] = []
        
        for contact in contacts {
            let fullName = "\(contact.givenName) \(contact.familyName)".trimmingCharacters(in: .whitespaces)
            
            if let number = contact.phoneNumbers.first {
                let raw = number.value.stringValue
                let digits = raw.filter(\.isWholeNumber)
                if !digits.isEmpty {
                    results.append(SyncedContact(fullName: fullName, phoneNumber: digits))
                }
            }
        }
        
        return results
    }
}
