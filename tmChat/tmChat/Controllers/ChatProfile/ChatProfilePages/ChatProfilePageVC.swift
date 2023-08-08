//
//  ChatProfilePageVC.swift
//  tmchat
//
//  Created by Shirin on 3/14/23.
//

import UIKit
import MXParallaxHeader
import Parchment

class ChatProfilePageVC: PagingViewController {

    
    let titles = ["images".localized(),
                  "videos".localized(),
                  "audio".localized(),
                  "voice_msg".localized()]

    let vcs: [UIViewController.Type] = [ ImageListVC.self,
                                         FileListVC.self,
                                         FileListVC.self,
                                         FileListVC.self]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMenubar()
        dataSource = self
        
        let v = UIView()
        v.backgroundColor = .red
        
//        collectionView.parallaxHeader.view = v
//        collectionView.parallaxHeader.mode = .fill
//        collectionView.parallaxHeader.height = 300
//        collectionView.parallaxHeader.delegate = self
//        
//        print(parallaxHeader)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        parallaxHeader?.minimumHeight = view.safeAreaInsets.top
    }
    

    func setupMenubar(){
        menuItemSize = .selfSizing(estimatedWidth: 100, height: 40)
        menuItemSpacing = -10
        menuBackgroundColor = .clear
        borderColor = .clear
        indicatorColor = .accent
        indicatorOptions = .visible(height: 3,
                                    zIndex: 0,
                                    spacing: UIEdgeInsets(horizontalEdges: 18),
                                    insets: .zero)

        font = .text_14_m!
        selectedFont = .text_14_m!
        selectedTextColor = .blade
        textColor = .lee
    }
}

extension ChatProfilePageVC: MXParallaxHeaderDelegate {
    
}

extension ChatProfilePageVC: PagingViewControllerDataSource {
    func numberOfViewControllers(in _: PagingViewController) -> Int {
        return titles.count
    }
    
    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
        return PagingIndexItem(index: index, title: titles[index])
    }

    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
//        return vcs[index].init()
        UIViewController()
    }
}
