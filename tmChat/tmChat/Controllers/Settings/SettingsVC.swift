//
//  SettingsVC.swift
//  tmchat
//
//  Created by Shirin on 4/17/23.
//

import UIKit
import EasyPeasy

class SettingsVC: UIViewController {

    var data = [SettingsModel(title: "",
                              content: [SettingModel(title: "update_profile",
                                                     iconName: "update-profile",
                                                     type: .editProfile)]),
                
//                SettingsModel(title: "app_settings",
//                              content: [
////                                SettingModel(title: "notifications",
////                                                     iconName: "notification",
////                                                     type: .notification),
////
////                                        SettingModel(title: "privacy",
////                                                     iconName: "privacy",
////                                                     type: .privacy),
//
//                                        SettingModel(title: "memory",
//                                                     iconName: nil,
//                                                     type: .memory),
//
//                                        SettingModel(title: "language",
//                                                     iconName: nil,
//                                                     type: .language),
//                              ]),
                
                SettingsModel(title: "account",
                              content: [SettingModel(title: "logout",
                                                     iconName: "logout",
                                                     type: .logout),

                                        SettingModel(title: "delete_acc",
                                                     iconName: "delete-acc",
                                                     type: .deleteAcc),
                              ]),

//                SettingsModel(title: "other",
//                              content: [SettingModel(title: "about_us",
//                                                     iconName: "right",
//                                                     type: .aboutUs),
//
//                                        SettingModel(title: "faq",
//                                                     iconName: "right",
//                                                     type: .faq),
//                              ])
    ]
    
    var sheetTransitioningDelegate = SheetTransitioningDelegate()
    
    var mainView: SettingsView {
        return view as! SettingsView
    }

    override func loadView() {
        super.loadView()
        view = SettingsView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCallbacks()
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    func setupCallbacks(){
        mainView.header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    func logout(){
        let vc = DeleteConfirmationBS()
        vc.mainView.title.text = "logout_title".localized()
        vc.mainView.desc.text = "logout_desc".localized()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        vc.deleteBtn.clickCallback = { [weak self] in
            vc.dismiss(animated: true)
            DatabaseManager.drop()
            AccUserDefaults.clear()
            SocketClient.shared.clear()
            self?.navigationController?.setViewControllers([EnterPhoneVC()], animated: true)
        }
        present(vc, animated: true)
    }
    
    func deleteAcc(){
        let vc = DeleteConfirmationBS()
        vc.mainView.title.text = "delete_user".localized()
        vc.mainView.desc.text = "delete_user_desc".localized()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        vc.deleteBtn.clickCallback = { [weak self] in
            vc.dismiss(animated: true)
            self?.deleteUser()
        }
        present(vc, animated: true)
    }
    
    func clearCache(){
        let vc = DeleteConfirmationBS()
        vc.mainView.title.text = "clear_cache".localized()
        vc.mainView.desc.text = "clear_cache_desc".localized()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        vc.deleteBtn.clickCallback = { [weak self] in
            vc.dismiss(animated: true) {
                CacheManager.clearAllCache()
                self?.mainView.tableView.reloadData()
            }
        }
        present(vc, animated: true)
    }

    func changeLang(){
        let vc = SelectLangBS()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate
        vc.langClickCallback = { [weak self] lang in
            vc.dismiss(animated: true) {
                self?.mainView.tableView.reloadData()
                guard let vc = self?.navigationController?.viewControllers.first as? TabbarController else { return }
                vc.setupVc()
            }
        }
        present(vc, animated: true)
    }
    
    func deleteUser(){
        mainView.showLoading()
        UserRequests.shared.deleteUser { [weak self] resp in
            if resp?.success == true {
                DatabaseManager.drop()
                AccUserDefaults.clear()
                self?.mainView.tableView.reloadData()
                self?.navigationController?.setViewControllers([EnterPhoneVC()], animated: true)
            }
        }
    }
}

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data[section].content.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let title = UILabel(font: .text_14_m,
                            color: .blade,
                            alignment: .left,
                            numOfLines: 0,
                            text: data[section].title.localized())
        
        let header = UIView()
        header.addSubview(title)
        title.easy.layout([
            Top(>=8), Bottom(8), Leading(26), Trailing(26)
        ])
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return !data[section].title.isEmpty ? 30 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTbCell.id, for: indexPath) as! SettingsTbCell
        cell.setupData(data[indexPath.section].content[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch data[indexPath.section].content[indexPath.row].type {
        case .logout:
            logout()
            
        case .deleteAcc:
            deleteAcc()
            
        case .memory:
            clearCache()
            
        case .language:
            changeLang()
            
        default:
            guard let vc = data[indexPath.section].content[indexPath.row].type.viewController else { return }
            navigationController?.pushViewController(vc.init(), animated: true)
        }
    }
}


enum Setting {
    case editProfile
    case notification
    case privacy
    case memory
    case language
    case faq
    case aboutUs
    case logout
    case deleteAcc
    
    var viewController: UIViewController.Type? {
        switch self {
        case .editProfile:
            return EditProfileVC.self
            
//        case .logout, .deleteAcc:
//            return nil
//
        default:
            return nil
        }
    }
}

struct SettingsModel {
    var title: String
    var content: [SettingModel]
}

struct SettingModel {
    var title: String
    var subtitle: String? = nil
    var iconName: String?
    var type: Setting
}
