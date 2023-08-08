//
//  EditPRofileVM.swift
//  tmchat
//
//  Created by Shirin on 3/18/23.
//

import Foundation

class EditProfileVM {
    
    var inProgress: Binder<Bool> = Binder(false)
    var success: Binder<Bool> = Binder(false)
    var user: Binder<User?> = Binder(nil)

    func getUser(){
        inProgress.value = true
        UserRequests.shared.getUser(id: AccUserDefaults.id) { [weak self] resp in
            self?.inProgress.value = false
            self?.user.value = resp?.data
        }
    }

    func updateProfile(data: UpdateUserParams, img: UploadImage? = nil){
        
        inProgress.value = true
        
        UserRequests.shared.updateUser(params: data) { [weak self] resp in
            if img == nil {
                self?.inProgress.value = false
                self?.success.value = resp?.success == true
                AccUserDefaults.saveUser(resp?.data)
                return
            }
            
            UserRequests.shared.updateProfileImg(params: img) { [weak self] resp in
                self?.inProgress.value = false
                self?.success.value = resp?.success == true
                AccUserDefaults.avatar = resp?.data ?? ""
            }
        }
    }
}
