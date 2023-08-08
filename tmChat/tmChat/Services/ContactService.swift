//
//  ContactService.swift
//  tmchat
//
//  Created by Shirin on 4/6/23.
//

import Foundation
import Contacts

struct Contact: Codable {
    var name: String
    var phone: String
}

class ContactService {

    func sendContactList(){
        
        fetchContacts { contactList in
            let contactsToSend = self.parseContacts(contactList)
            ChatRequests.shared.sendContacts(contacts: contactsToSend) { resp in
                AccUserDefaults.contactsSend = resp?.success ?? false
            }
            
        } requestNotGranted: {
            return
        }
    }
    
    func fetchContacts(_ success: @escaping ([CNContact]) -> Void,
                       requestNotGranted: @escaping () -> Void) {
        var contacts = [CNContact]()
        
        let store = CNContactStore()
        store.requestAccess(for: .contacts, completionHandler: {
            granted, error in
            
            guard granted else {
                requestNotGranted()
                return
            }
            
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactPhoneNumbersKey] as [Any]
            let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
            request.sortOrder = .userDefault
            
            do {
                try store.enumerateContacts(with: request){
                    (contact, cursor) -> Void in
                    contacts.append(contact)
                }
            } catch {
                debugPrint("Fetch contact error: \(error)")
            }
            
            success(contacts)
        })
    }
    
    func parseContacts(_ contactList: [CNContact]) -> [Contact] {
        var phones = [Contact]()
        
        for contact in contactList {
            
            for phone in contact.phoneNumbers {
                if let p = getPhone(phone.value.stringValue) {

                    let name = [contact.familyName,
                                contact.givenName,
                                contact.middleName]
                                        .joined(separator: " ")
                                        .trimmingCharacters(in: .whitespaces)
                                        .replacingOccurrences(of: "  ", with: " ")
                    
                    if phones.contains(where: {$0.phone == p}) == false && name.isEmpty == false {
                        phones.append(Contact(name: name,
                                              phone: p))
                    }
                }
            }
        }
        
        return phones
    }
    
    func getPhone(_ phone: String) -> String? {
        var p = phone
        p = p.replacingOccurrences(of: " ", with: "")
        p = p.replacingOccurrences(of: "(", with: "")
        p = p.replacingOccurrences(of: ")", with: "")
        p = p.replacingOccurrences(of: "+", with: "")
        p = p.replacingOccurrences(of: "-", with: "")

        if p.count == 9 && p.first == "8" {
            p = String(p.dropFirst())
            p = "993" + p
        }
        
        if !p.hasPrefix("993") {
            return nil
        }
        
        if p.count == 11 {
            return "+"+p
        }
        
        return nil
    }
}
