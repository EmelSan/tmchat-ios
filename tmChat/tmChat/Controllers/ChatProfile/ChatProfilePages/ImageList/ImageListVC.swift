//
//  ImageListVC.swift
//  tmchat
//
//  Created by Shirin on 3/23/23.
//

import UIKit

class ImageListVC: UIViewController {

    var mainView: ImageListView {
        return view as! ImageListView
    }

    override func loadView() {
        super.loadView()
        view = ImageListView()
        view.backgroundColor = .bg
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
}


extension ImageListVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 60
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedMediaCell.id, for: indexPath) as! FeedMediaCell
        return cell
    }
}
