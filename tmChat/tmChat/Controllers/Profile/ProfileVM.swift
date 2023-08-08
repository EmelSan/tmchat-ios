//
//  ProfileVM.swift
//  tmchat
//
//  Created by Shirin on 3/9/23.
//

import Foundation

class ProfileVM {
    
    var user: Binder<User?> = Binder(nil)
    var data: Binder<[PostData]> = Binder([])
    var inProgress: Binder<Bool> = Binder(false)
    var noContent: Binder<Bool> = Binder(false)
    var noConnection: Binder<Bool> = Binder(false)

    var params = PaginationParams(page: 1)
    var lastPage = false
    var postCount: Int = 0

    func getUser(){
        UserRequests.shared.getUser(id: params.ownerId ?? AccUserDefaults.id) { [weak self] resp in
            self?.user.value = resp?.data
        }
    }
    
    func getFeed(forPage: Int){
        if inProgress.value || (lastPage && forPage != 1) { return }
        if params.page == 1 {
            inProgress.value = true
        }
        var params = params
        params.page = forPage
        
        FeedRequests.shared.getFeed(params: params) { [weak self] resp in
            guard let s = self else { return }

            s.inProgress.value = false

            guard let resp = resp else {
                s.noConnection.value = forPage == 1
                return
            }

            s.noConnection.value = false
            s.lastPage = (resp.data?.rows ?? []).isEmpty

            
            s.postCount = resp.data?.count ?? 0
            if forPage == 1 {
                s.data.value = resp.data?.rows ?? []
            } else {
                s.data.value.append(contentsOf: resp.data?.rows ?? [])
            }

            s.params.page = forPage
        }
    }
    
    func toggleLike(uuid: String){
        FeedRequests.shared.toggleLike(uuid: uuid) { [weak self] resp in
            guard let data = resp?.data else { return }
            guard let ind = self?.data.value.firstIndex(where: {$0.uuid == uuid }) else { return }
            self?.data.value[ind] = data
        }
    }
    
    func deletePost(uuid: String?){
        guard let uuid = uuid else { return }
        FeedRequests.shared.deletePost(uuid: uuid) { [weak self] resp in
            if resp?.success == true {
                self?.data.value.removeAll(where: {$0.uuid == uuid })
            }
        }
    }
}
