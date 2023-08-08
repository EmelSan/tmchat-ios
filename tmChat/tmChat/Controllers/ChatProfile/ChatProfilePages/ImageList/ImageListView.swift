//
//  ImageListView.swift
//  tmchat
//
//  Created by Shirin on 3/23/23.
//

import UIKit
import EasyPeasy

class ImageListView: BaseView {

    var collectionView = UICollectionView(scrollDirection: .vertical,
                                          itemSize: DeviceDimensions.imgListCellDimensions,
                                          minimumLineSpacing: 1,
                                          minimumInteritemSpacing: 1)
                                          
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(FeedMediaCell.self, forCellWithReuseIdentifier: FeedMediaCell.id)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(collectionView)
        collectionView.easy.layout([
            Top(12), Leading(1), Trailing(1), Bottom()
        ])
    }
}
