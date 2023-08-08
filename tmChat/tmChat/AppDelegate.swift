//
//  AppDelegate.swift
//  tmchat
//
//  Created by Shirin on 3/7/23.
//

import UIKit
import Localize_Swift
import Kingfisher
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    var tabbar: TabbarController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        setupLang()
        setupPush()
        
        DatabaseManager.setup(for: application)
        MessageTable.shared.updateToError()
        RoomTable.shared.makeAllOfline()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: getStartVC())

        return true
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
        KingfisherManager.shared.cache.cleanExpiredDiskCache()
    }
        
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
        }

    func getStartVC() -> UIViewController {
        if !AccUserDefaults.username.isEmpty {
            tabbar = TabbarController()
            return tabbar!
        }
        
        return EnterPhoneVC()
    }
    
    func setupLang(){
        if AccUserDefaults.language.isEmpty {
            Localize.setCurrentLanguage("ru")
            AccUserDefaults.language = "ru"
        }
    }
    
    func setupPush(){

        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )

        UIApplication.shared.registerForRemoteNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self

    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter( _ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void ) {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter( _ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void ) {
        let userInfo = response.notification.request.content.userInfo
        guard let type = userInfo[AnyHashable("type")] as? String else { return }
        let decoder = JSONDecoder()
        
        if type.contains("MESSAGE") {
            guard let roomData = (userInfo[AnyHashable("room")] as? String)?.data(using: .utf8) else { return }
            guard let msgData = (userInfo[AnyHashable("message")] as? String)?.data(using: .utf8) else { return }
            
            guard var room = try? decoder.decode(Room.self, from: roomData) else { return }
            guard var msg = try? decoder.decode(Message.self, from: msgData) else { return }

            room.id = RoomTable.shared.upsertRoom(room: room)
            msg.roomId = room.id
            MessageTable.shared.upsertMsg(msg: msg)
            
            guard let vc = tabbar?.viewControllers?.first as? ChatlistVC else { return }
            vc.openMessaging(data: room)
            
        } else if type.contains("POST") {
            guard let uuid = (userInfo[AnyHashable("post")] as? String)?.data(using: .utf8) else { return }
            guard var id = try? decoder.decode(Uuid.self, from: uuid) else { return }
            let vc = OnePostVC()
            vc.id = id.uuid
            tabbar?.navigationController?.pushViewController(vc, animated: true)
        }

        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("ACC", fcmToken)
        AccUserDefaults.fcm = fcmToken ?? "fcmToken"
    }
}

struct Uuid: Codable {
    var uuid: String
}
