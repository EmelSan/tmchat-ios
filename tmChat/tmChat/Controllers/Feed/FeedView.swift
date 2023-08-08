//
//  FeedView.swift
//  tmchat
//
//  Created by Shirin on 3/9/23.
//

import UIKit
import EasyPeasy

class FeedView: BaseView {

    let header = SearchHeader()
    
    let simpleHeader = Header(title: "post")
    
    let paginationSpinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0,
                                                    width: DeviceDimensions.width,
                                                    height: 44))
    
    let tableView: UITableView = {
        let t = UITableView(rowHeight: UITableView.automaticDimension,
                            estimatedRowHeight: 400,
                            backgroundColor: .clear)
        t.register(FeedTbCell.self, forCellReuseIdentifier: FeedTbCell.id)
        t.refreshControl = UIRefreshControl()
        t.keyboardDismissMode = .interactive
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(header)
        header.easy.layout([
            Leading(), Trailing(), Top().to(safeAreaLayoutGuide, .top)
        ])
        
        addSubview(simpleHeader)
        simpleHeader.isHidden = true
        simpleHeader.easy.layout([
            Leading(), Trailing(), Top().to(safeAreaLayoutGuide, .top)
        ])
        
        addSubview(tableView)
        tableView.easy.layout([
            Top().to(header, .bottom), Leading(), Trailing(), Bottom().to(safeAreaLayoutGuide, .bottom)
        ])
        
        addSubview(fabBtn)
        fabBtn.easy.layout([
            Trailing(14), Bottom(14).to(safeAreaLayoutGuide, .bottom)
        ])
    }
    
    @objc func refresh(){
        tableView.refreshControl?.endRefreshing()
        refreshCallback?()
    }
}
