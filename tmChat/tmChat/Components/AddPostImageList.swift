//
//  ImageList.swift
//  tmchat
//
//  Created by Shirin on 3/12/23.
//

import UIKit
import TLPhotoPicker
import EasyPeasy

class AddPostImageList: UIView {

    weak var delegate: ImageListDelegate?
    
    var images: [UIImage?] = [] {
        didSet {
            isHidden = images.isEmpty
            setupData()
        }
    }

    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 8)
    
    var title = UILabel(font: .text_14_r,
                        color: .blade,
                        alignment: .left,
                        numOfLines: 0)
    
    var collectionView = UICollectionView(scrollDirection: .vertical,
                                          itemSize: DeviceDimensions.imgCellDimensions,
                                          minimumLineSpacing: 11)
    
    init(title: String) {
        super.init(frame: .zero)
        collectionView.register(ImgCell.self, forCellWithReuseIdentifier: ImgCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupView()
        self.title.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(contentStack)
        contentStack.easy.layout([
            Edges()
        ])
        
        contentStack.addArrangedSubviews([title, collectionView])
    }
    
    func setupData(){
        let rows = Int((Double(images.count)/3.0).rounded(.up))
        let height = rows * Int(DeviceDimensions.imgCellDimensions.height)
                        + (rows > 1 ? rows : 0) * 11
        collectionView.reloadData()
        collectionView.easy.layout(Height(CGFloat(height)))
    }
}

extension AddPostImageList: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImgCell.id, for: indexPath) as! ImgCell
        cell.setupData(img: images[indexPath.item])
        cell.deleteBtn.clickCallback = { [weak self] in
            self?.delegate?.deleteClicked(indexPath.item)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.imageClicked(indexPath.item)
    }
}
