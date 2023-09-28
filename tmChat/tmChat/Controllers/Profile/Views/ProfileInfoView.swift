//
//  ProfileInfoView.swift
//  tmchat
//
//  Created by Farid Guliev on 20.08.2023.
//

import UIKit
import EasyPeasy

final class ProfileInfoView: UIStackView {

    private let icon = UIImageView(contentMode: .scaleAspectFit,
                                   cornerRadius: 0,
                                   image: UIImage(named: "open"),
                                   backgroundColor: .clear)

    private let titleLabel = UILabel(font: .semibold(size: 14),
                                     color: .lee,
                                     alignment: .left,
                                     numOfLines: 1,
                                     text: "about_yourself".localized())

    private let aboutLabel = UILabel(font: .regular(size: 14), numOfLines: 1)

    private let contentStackView = UIStackView(axis: .vertical, alignment: .leading, spacing: 4)

    var info: String = "" {
        didSet {
            aboutLabel.text = info
        }
    }

    var clickCallback: ( ()->() )?

    init() {
        super.init(frame: .zero)

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(click)))
        setupView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {

        spacing = 20
        alignment = .center

        addMargins(left: 4, right: 0)

        contentStackView.addArrangedSubviews([titleLabel, aboutLabel])
        addArrangedSubviews([icon, contentStackView])
    }

    @objc
    private func click() {
        clickCallback?()
    }
}
