//
//  TabbarController.swift
//  tmchat
//
//  Created by Shirin on 3/9/23.
//

import UIKit

class TabbarController: BubbleTabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.clipsToBounds = true
        
        setupVc()
        connectToSocekt()
        sendContacts()
        
//        ChatRequests.shared.getContacts { resp in
//            print(resp)
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.navigationBar.isHidden = true
    }
    
    func setupVc(){
        let chatlist = ChatlistVC()
        chatlist.tabBarItem = UITabBarItem(title: "chats".localized(),
                                           image: UIImage(named: "chat"),
                                           selectedImage: UIImage(named: "chat-active"))
        
        let feed = FeedVC()
        feed.tabBarItem = UITabBarItem(title: "feed".localized(),
                                           image: UIImage(named: "feed"),
                                           selectedImage: UIImage(named: "feed-active"))

        let profile = ProfileVC(type: .own)
        profile.tabBarItem = UITabBarItem(title: "profile".localized(),
                                           image: UIImage(named: "profile"),
                                           selectedImage: UIImage(named: "profile-active"))

        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(title: "profile".localized(),
                                           image: UIImage(named: "profile"),
                                           selectedImage: UIImage(named: "profile-active"))

        setViewControllers([chatlist, feed, profile], animated: false)
    }
    
    func connectToSocekt(){
        ChatRequests.shared.getRooms { resp in
            RoomTable.shared.upsertRooms(rooms: resp?.data ?? [])
            SocketClient.shared.connect()
        }
    }
    
    func sendContacts(){
        if AccUserDefaults.contactsSend { return }
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let _ = self else { return }
            ContactService().sendContactList()
        }
    }
}
