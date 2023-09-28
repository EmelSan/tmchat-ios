//
//  ProfileView.swift
//  tmchat
//
//  Created by Shirin on 3/9/23.
//

import UIKit
import EasyPeasy

class ProfileView: BaseView {

    var header = ProfileHeaderView()
    
    let paginationSpinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0,
                                                    width: DeviceDimensions.width,
                                                    height: 44))

    let avatarImageView = UIImageView(contentMode: .scaleAspectFill, cornerRadius: 0)

    let tableView: UITableView = {
        let t = UITableView(style: .grouped,
                            rowHeight: UITableView.automaticDimension,
                            estimatedRowHeight: 400,
                            backgroundColor: .clear)
        t.register(FeedTbCell.self, forCellReuseIdentifier: FeedTbCell.id)
        t.register(NoContentTbCell.self, forCellReuseIdentifier: NoContentTbCell.id)
        t.register(ProfileTbHeader.self, forHeaderFooterViewReuseIdentifier: ProfileTbHeader.id)
        t.sectionHeaderHeight = UITableView.automaticDimension
        t.refreshControl = UIRefreshControl()
        t.keyboardDismissMode = .interactive
        t.contentInset.top = 296
        return t
    }()
    
    let fabBtn = FabBtn(title: "new_post".localized(), iconName: "add-circle")

    var refreshCallback: ( ()->() )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        paginationSpinner.stopAnimating()
        tableView.tableFooterView = paginationSpinner
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)

        setupView()
        self.sendSubviewToBack(noConnection)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(avatarImageView)
        addSubview(tableView)
        addSubview(header)
        addSubview(fabBtn)

        tableView.easy.layout([
            Top().to(header, .bottom), Leading(), Trailing(),
            Bottom().to(safeAreaLayoutGuide, .bottom)
        ])
        header.easy.layout([
            Top(), Leading(), Trailing()
        ])
        avatarImageView.easy.layout([
            Top(), Leading(), Trailing(), Width(), Height(414)
        ])

        fabBtn.isHidden = true
        fabBtn.easy.layout([
            Trailing(14), Bottom(14).to(safeAreaLayoutGuide, .bottom)
        ])
    }
    
    func otherProfile(){
        fabBtn.title.text = "send_msg".localized()
        fabBtn.icon.image = UIImage(named: "pencil")
    }
    
    func addBgToHeader(){
        header.backgroundColor = .bg
        header.setupWithColor(.blade)
    }
    
    func removeBgFromHeader(){
        header.backgroundColor = .clear
        header.setupWithColor(.lightClear)
        header.setupGradient()
    }

    func setAvatar(url: URL, colorCode: String) {
        avatarImageView.kf.setImage(with: url)
        avatarImageView.backgroundColor = UIColor(hexString: colorCode)
    }
    
    @objc func refresh(){
        tableView.refreshControl?.endRefreshing()
        refreshCallback?()
    }
}

