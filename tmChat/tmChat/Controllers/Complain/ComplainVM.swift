//
//  ComplainVM.swift
//  tmchat
//
//  Created by Ширин Янгибаева on 01.06.2023.
//

import Foundation

class ComplainVM {
    
    var uuid: String = ""
    var user = false
    
    var success: Binder<Bool> = Binder(false)
    var inProgress: Binder<Bool> = Binder(false)

    func sendReport(text: String){
        inProgress.value = true
        FeedRequests.shared.reportPost(uuid: uuid, text: text) { [weak self] resp in
            self?.inProgress.value = false
            self?.success.value = resp?.success ?? false
        }
    }
}

