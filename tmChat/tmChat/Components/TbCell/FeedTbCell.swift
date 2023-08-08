//
//  FeedTbCell.swift
//  tmchat
//
//  Created by Shirin on 3/11/23.
//

import UIKit
import EasyPeasy

class FeedTbCell: UITableViewCell {

    static let id = "FeedTbCell"
    
    var data: PostData? {
        didSet {
            setupData()
        }
    }
    
    var contentStack = UIStackView(axis: .vertical,
                                   alignment: .fill,
                                   spacing: 10,
                                   edgeInsets: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    
    var userDataStack = UserDataStack()
    
    var postCount = PostPageCount()
    
    var mediaCollectionView = UICollectionView(scrollDirection: .horizontal,
                                               itemSize: DeviceDimensions.postCellDimensions,
                                               isPagingEnabled: true)
    
    var textWrapper = UIStackView(axis: .vertical,
                                  alignment: .fill,
                                  spacing: 0,
                                  edgeInsets: UIEdgeInsets(horizontalEdges: 10))
    
    var text = UILabel(font: .text_14_r,
                       color: .blade,
                       alignment: .left,
                       numOfLines: 0)
    
    var btnStack = UIStackView(axis: .horizontal,
                               alignment: .center,
                               spacing: 10,
                               edgeInsets: UIEdgeInsets(horizontalEdges: 10))
    
    var seenCount = SeenCountView()
    
    var likeBtn = LikeBtn()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        mediaCollectionView.register(FeedMediaCell.self, forCellWithReuseIdentifier: FeedMediaCell.id)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        userDataStack.profileImg.img.image = nil
    }
        
    func setupView(){
        contentView.addSubview(contentStack)
        contentStack.easy.layout([
            Top(), Leading(), Trailing(), Bottom(10)
        ])
        
        textWrapper.addArrangedSubview(text)
        
        btnStack.addArrangedSubviews([seenCount,
                                      UIView(),
                                      likeBtn])
    }
    
    func setupCollectionView(){
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        
        mediaCollectionView.easy.layout([
            Height(DeviceDimensions.postCellDimensions.height).with(.high)
        ])

        contentStack.addSubview(postCount)
        postCount.easy.layout([
            Top(10).to(mediaCollectionView, .top),
            Leading(10).to(mediaCollectionView, .leading)
        ])
    }
    
    func setupContentStack(){
        contentStack.removeSubviews()
        let _ = contentStack.addBackground(color: .white, cornerRadius: 0)
        contentStack.addArrangedSubview(userDataStack)
        
        if (data?.files?.count ?? 0) > 0 {
            contentStack.addArrangedSubview(mediaCollectionView)
            setupCollectionView()
        } else {
            mediaCollectionView.removeFromSuperview()
        }
        
        contentStack.addArrangedSubviews([textWrapper,
                                          btnStack])
    }
    
    func setupData(){
        guard let data = data else { return }
        setupContentStack()
        userDataStack.setupData(data.owner)
        userDataStack.desc.text = TimeAgo.shared.getAgo(data.createdAt?.getDate())
        mediaCollectionView.reloadData()
        text.text = data.description
        seenCount.title.text = data.viewCount
        likeBtn.isHidden = !data.isLikeable
        likeBtn.data = LikeData(isLiked: data.isLiked,
                                count: data.likeCount )
    }
}


extension FeedTbCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        postCount.count = data?.files?.count ?? 0
        return data?.files?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedMediaCell.id, for: indexPath) as! FeedMediaCell
        cell.setupData(data: data?.files?[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? FeedMediaCell
        cell?.player?.seek(to: .zero)
        cell?.player?.pause()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        postCount.current = Int(scrollView.contentOffset.x )/Int(scrollView.bounds.width)
    }
}
