//
//  ContactListVM.swift
//  tmchat
//
//  Created by Shirin on 4/9/23.
//

import Foundation

class ContactListVM {
    
    var data: Binder<[User]> = Binder([])
    var inProgress: Binder<Bool> = Binder(false)
    var noConnection: Binder<Bool> = Binder(false)
    var noContent: Binder<Bool> = Binder(false)

    var params = PaginationParams(page: 1)
    var lastPage = false
    
    func getContacts(forPage: Int){
        if lastPage || inProgress.value { return }
        
        if params.page == 1 {
            inProgress.value = true
        }
        
        var params = params
        params.page = forPage
        ChatRequests.shared.getContacts(params: params) { [weak self] resp in
            guard let s = self else { return }

            s.inProgress.value = false

            guard let resp = resp else {
                s.noConnection.value = forPage == 1
                return
            }

            s.noConnection.value = false
            s.noContent.value = (resp.data?.rows ?? []).isEmpty && forPage == 1
            s.lastPage = (resp.data?.rows ?? []).isEmpty

            if forPage == 1 {
                s.data.value = resp.data?.rows ?? []
            } else {
                s.data.value.append(contentsOf: resp.data?.rows ?? [])
            }

            s.params.page = forPage
        }
    }
}
