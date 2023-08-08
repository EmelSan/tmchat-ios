//
//  OtpVm.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import Foundation

class OtpVM {
    
    var inProgress: Binder<Bool> = Binder(false)
    var response: Binder<CheckOtpResponse?> = Binder(nil)
    
    func checkOtp(_ code: String){
        
        inProgress.value = true
        
        UserRequests.shared.checkOtp(code: code) { [weak self] resp in
            self?.inProgress.value = false
            
            AccUserDefaults.saveUser(resp?.data?.user)
            AccUserDefaults.token = resp?.data?.token ?? ""

            self?.response.value = resp?.data
        }
    }
    
    func resendOtp(){
        
        inProgress.value = true
        
        UserRequests.shared.sendOtp(phone: "+993"+AccUserDefaults.phone) { [weak self] resp in
            self?.inProgress.value = false
            if resp?.success == true {
                PopUpLauncher.showSuccessMessage(text: "otp_resent".localized())
            }
        }
    }

}
