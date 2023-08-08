//
//  UsernameVM.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import Foundation

class UsernameVM {
    
    var inProgress: Binder<Bool> = Binder(false)
    var response: Binder<User?> = Binder(nil)
    
    func sendName(_ name: String){
        
        inProgress.value = true
        let params = UpdateUserParams(firstName: name)
        
        UserRequests.shared.updateUser(params: params) { [weak self] resp in
            
            self?.inProgress.value = false
            if resp?.success == true {
                AccUserDefaults.firstName = name
                self?.response.value = resp?.data
            }
        }
    }

    func sendUserName(_ name: String){
        
        inProgress.value = true
        
        let params = UpdateUserParams(username: name)
        
        UserRequests.shared.updateUser(params: params) { [weak self] resp in
            
            self?.inProgress.value = false
            if resp?.success == true {
                AccUserDefaults.username = name
                self?.response.value = resp?.data
            }
        }
    }
}
