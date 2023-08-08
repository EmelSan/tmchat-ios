//
//  AddPostVM.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import Foundation

class AddPostVM {
    
    var inProgress: Binder<Bool> = Binder(false)
    var success: Binder<Bool> = Binder(false)
    
    func addPost(params: [String: String], files: [UploadImage]){
        inProgress.value = true
        
        FeedRequests.shared.addPost(params: params, files: files) { [weak self] resp in
            if resp?.success == true {
                self?.success.value = true
            } else {
                PopUpLauncher.showErrorMessage(text: "could_not_add".localized())
            }
        }
    }
}
