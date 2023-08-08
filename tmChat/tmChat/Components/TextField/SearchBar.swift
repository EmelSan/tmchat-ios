//
//  SearchBar.swift
//  tmchat
//
//  Created by Shirin on 3/9/23.
//

import UIKit
import EasyPeasy

class SearchBar: UISearchBar {
    
    var timer: Timer?
    var beginEditingCallback: ( () -> Void )?
    var cancelClickCallback: (() -> Void)?
    var editingCallback: ((String?) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
        
        setupView()
        setupCancelBtn()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        backgroundColor = .clear
        layer.cornerRadius = 18
        searchBarStyle = .minimal

        if #available(iOS 13.0, *) {
            searchTextField.backgroundColor = .onBg
            if let searchIcon = searchTextField.leftView as? UIImageView {
                let img = searchIcon.image?.withRenderingMode(.alwaysTemplate)
                searchIcon.image = img
                searchIcon.tintColor = .blade
            }
        }
    }
    
    func setupCancelBtn(){
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.accent,
            NSAttributedString.Key.font: UIFont.text_14_m ?? .systemFont(ofSize: 14)
        ], for: UIControl.State.normal)

        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "cancel".localized()
    }
    
    @objc func delayedSearch() {
        editingCallback?(self.text ?? "")
    }
}

extension SearchBar: UISearchBarDelegate {
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if beginEditingCallback != nil {
            beginEditingCallback?()
            return false
        }

        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.showsCancelButton = true
        searchBar.sizeToFit()
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.showsCancelButton = false
        searchBar.sizeToFit()
        searchBar.resignFirstResponder()
        cancelClickCallback?()
        editingCallback?(searchBar.text)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(delayedSearch), userInfo: nil, repeats: false)
    }
}
