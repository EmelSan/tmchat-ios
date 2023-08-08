//
//  UserDefaults.swift
//  Meninki
//
//  Created by NyanDeveloper on 12.12.2022.
//

import Foundation

private enum Defaults: String {
    case language = "language"
    case token = "token"
    case fcm = "fcm"
    case contactsSend = "contacts-send"

    case id = "user-id"
    case phone = "phone"
    case username = "username"
    case firstname = "firstname"
    case lastname = "lastname"
    case desc = "desc"
    case avatar = "avatar"
}

class AccUserDefaults {

    static var language: String {
        set { _set(value: newValue, key: .language) }
        get { return _get(valueForKey: .language) as? String ?? "" }
    }

    static var id: String {
        set { _set(value: newValue, key: .id) }
        get { return _get(valueForKey: .id) as? String ?? "" }
    }

    static var token: String {
        set { _set(value: newValue, key: .token) }
        get { return _get(valueForKey: .token) as? String ?? "" }
    }

    static var fcm: String {
        set { _set(value: newValue, key: .fcm) }
        get { return _get(valueForKey: .fcm) as? String ?? "fcm" }
    }

    static var phone: String {
        set { _set(value: newValue, key: .phone) }
        get { return _get(valueForKey: .phone) as? String ?? "" }
    }

    static var username: String {
        set { _set(value: newValue, key: .username) }
        get { return _get(valueForKey: .username) as? String ?? "" }
    }

    static var firstName: String {
        set { _set(value: newValue, key: .firstname) }
        get { return _get(valueForKey: .firstname) as? String ?? "" }
    }

    static var lastName: String {
        set { _set(value: newValue, key: .lastname) }
        get { return _get(valueForKey: .lastname) as? String ?? "" }
    }
    
    static var desc: String {
        set { _set(value: newValue, key: .desc) }
        get { return _get(valueForKey: .desc) as? String ?? "" }
    }
    
    static var avatar: String {
        set { _set(value: newValue, key: .avatar) }
        get { return _get(valueForKey: .avatar) as? String ?? "" }
    }

    static var name: String {
        get { return (firstName+" "+lastName).trimmingCharacters(in: .whitespaces).isEmpty
                        ? username :  firstName+" "+lastName }
    }

    static var contactsSend: Bool {
        set { _set(value: newValue, key: .contactsSend) }
        get { return _get(valueForKey: .contactsSend) as? Bool ?? false}
    }

    static func saveUser(_ user: User?){
        guard let user = user else { return }
        username = user.username ?? ""
        firstName = user.firstName ?? ""
        lastName = user.lastName ?? ""
        desc = user.description ?? ""
        avatar = user.avatar ?? ""
        phone = user.phone ?? ""
    }
    
    static func clear(){
        token = ""
        contactsSend = false
        id = ""
        phone = ""
        username = ""
        firstName = ""
        lastName = ""
        desc = ""
        avatar = ""
    }
}

extension AccUserDefaults {
    private static func _set(value: Any?, key: Defaults) {
        UserDefaults.standard.setValue(value, forKey: key.rawValue)
    }

    private static func _get(valueForKey key: Defaults)-> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue)
    }
}
