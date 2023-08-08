//
//  SearchVM.swift
//  tmchat
//
//  Created by Shirin on 4/9/23.
//

import Foundation

class SearchVM {
    
    var data: Binder<[User]> = Binder([])
    var inProgress: Binder<Bool> = Binder(false)
    var noConnection: Binder<Bool> = Binder(false)
    var noContent: Binder<Bool> = Binder(false)

    func getUsers(searchKey: String){
        inProgress.value = true
        UserRequests.shared.searchUser(searchKey: searchKey) { [weak self] resp in
            self?.inProgress.value = false
            self?.noConnection.value = resp == nil
            self?.noContent.value = resp?.data == nil || resp?.data?.isEmpty == true
            self?.data.value = resp?.data ?? []
        }
    }
}
