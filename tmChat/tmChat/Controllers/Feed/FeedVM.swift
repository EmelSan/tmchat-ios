//
//  FeedVM.swift
//  tmchat
//
//  Created by Shirin on 3/9/23.
//

import Foundation

class FeedVM {
 
    var data: [PostData] = []
    var inProgress: Binder<Bool> = Binder(false)
    var noContent: Binder<Bool> = Binder(false)
    var noConnection: Binder<Bool> = Binder(false)
    var reloadData: Binder<Bool> = Binder(false)
    var reloadIndPath: Binder<IndexPath?> = Binder(nil)
    var deleteIndPath: Binder<IndexPath?> = Binder(nil)

    var params = PaginationParams(page: 1)
    var lastPage = false
    
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
            s.noContent.value = (resp.data?.rows ?? []).isEmpty && forPage == 1
            s.lastPage = (resp.data?.rows ?? []).isEmpty

            if forPage == 1 {
                s.data = resp.data?.rows ?? []
            } else {
                s.data.append(contentsOf: resp.data?.rows ?? [])
            }

            s.reloadData.value = true
            s.params.page = forPage
        }
    }
    
    func getPost(id: String){
        inProgress.value = true

        FeedRequests.shared.getPost(uuid: id) { [weak self] resp in
            self?.inProgress.value = false
            guard let data = resp?.data else {
                self?.noConnection.value = true
                return
            }

            self?.data = [data]
            self?.reloadData.value = true
        }
    }
    
    func toggleLike(uuid: String){
        FeedRequests.shared.toggleLike(uuid: uuid) { [weak self] resp in
            guard let ind = self?.data.firstIndex(where: {$0.uuid == uuid }) else { return }

            guard let data = resp?.data else {
                self?.reloadIndPath.value = IndexPath(row: ind, section: 0)
                return
            }
            
            self?.data[ind].isLiked = data.isLiked
            self?.data[ind].likeCount = data.likeCount
        }
    }
    
    func deletePost(uuid: String?){
        guard let uuid = uuid else { return }
        FeedRequests.shared.deletePost(uuid: uuid) { [weak self] resp in
            if resp?.success == true {
                guard let ind = self?.data.firstIndex(where: {$0.uuid == uuid }) else { return }
                self?.data.remove(at: ind)
                self?.deleteIndPath.value = IndexPath(row: ind, section: 0)
            }
        }
    }
}
