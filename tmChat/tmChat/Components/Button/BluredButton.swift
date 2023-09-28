//
//  BluredButton.swift
//  tmchat
//
//  Created by Farid Guliev on 22.08.2023.
//

import UIKit
import EasyPeasy

final class BluredButton: UIButton {

    var clickCallback: ( () -> Void )?

    private let iconImageView = UIImageView()

    init(image: UIImage?) {
        super.init(frame: .zero)

        setup(image: image)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        nil
    }

    func setImage(named: String) {
        iconImageView.image = UIImage(named: named)
    }

    private func setup(image: UIImage?) {
        layer.cornerRadius = 20.0
        clipsToBounds = true

        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        addSubview(blurView)

        blurView.easy.layout(Edges())

        iconImageView.image = image
        addSubview(iconImageView)

        iconImageView.easy.layout([
            Size(20), Center()
        ])

        easy.layout(Size(40))
        addTarget(self, action: #selector(click), for: .touchUpInside)
    }

    @objc
    private func click() {
        clickCallback?()
    }
}

