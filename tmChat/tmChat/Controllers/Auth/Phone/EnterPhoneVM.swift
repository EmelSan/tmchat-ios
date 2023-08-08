//
//  EnterPhoneVM.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import Foundation

class EnterPhoneVM {
    
    var inProgress: Binder<Bool> = Binder(false)
    var userId: Binder<String?> = Binder(nil)
    
    func sendOtp(_ toNumber: String){
        
        inProgress.value = true
        
        UserRequests.shared.sendOtp(phone: "+993"+toNumber) { [weak self] resp in
            self?.inProgress.value = false
            if resp?.success == true {
                self?.userId.value = resp?.data?.userId
                AccUserDefaults.phone = toNumber
            }
        }
    }
}
