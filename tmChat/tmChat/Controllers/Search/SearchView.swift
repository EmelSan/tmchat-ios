//
//  SearchView.swift
//  tmchat
//
//  Created by Shirin on 4/9/23.
//

import UIKit
import EasyPeasy

class SearchView: BaseView {
    
    var headerBg = UIView()
    
    var header = UIStackView(axis: .horizontal,
                             alignment: .fill,
                             spacing: 8,
                             edgeInsets: UIEdgeInsets(edges: 4))
    
    var backBtn = IconBtn(image: UIImage(named: "back"), color: .blade)
    
    var clearBtn = IconBtn(image: UIImage(named: "close"), color: .blade)
    
    var searchField: UITextField = {
        let t = UITextField()
        t.font = .sb_16_m
        t.textColor = .blade
        t.placeholder = "serach_user".localized()
        return t
    }()
    
    var tableView = UITableView(rowHeight: UITableView.automaticDimension)
    
    private var timer: Timer?
    var editingCallback: ((String?) -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.register(ContactTbCell.self, forCellReuseIdentifier: ContactTbCell.id)
        
        setupView()
        setupHeader()
        searchField.addTarget(self,
                              action: #selector(didChangeText),
                              for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(header)
        header.easy.layout([
            Top().to(safeAreaLayoutGuide, .top), Leading(14), Trailing(14),
        ])
        
        addSubview(tableView)
        tableView.easy.layout([
            Top(14).to(header, .bottom), Leading(), Trailing(), Bottom().to(safeAreaLayoutGuide, .bottom)
        ])
    }
    
    func setupHeader(){
        headerBg = header.addBackground(color: .onBg,
                                        cornerRadius: 10)
        
        header.addArrangedSubviews([backBtn,
                                    searchField,
                                    clearBtn])
    }
    
    @objc func didChangeText(){
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(delayedSearch), userInfo: nil, repeats: false)
    }
    
    @objc func delayedSearch(){
        editingCallback?(searchField.text?.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
