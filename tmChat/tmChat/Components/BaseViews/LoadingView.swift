//
//  LoadingView.swift
//  Guncha
//
//  Created by Shirin on 2/15/23.
//

import UIKit
import EasyPeasy

class LoadingView: UIView {
    
    var loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.color = .white
        loading.backgroundColor = .blade.withAlphaComponent(0.8)
        loading.layer.cornerRadius = 10
        loading.stopAnimating()
        return loading
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        addSubview(loading)
        loading.easy.layout([
            CenterY().to(self, .centerY), CenterX(), Size(80)
        ])
    }
}
