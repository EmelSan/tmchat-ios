//
//  ProfileHeaderView.swift
//  tmchat
//
//  Created by Farid Guliev on 19.08.2023.
//

import UIKit

final class ProfileHeaderView: UIStackView {
    
    var backBtn = IconBtn(image: UIImage(named: "back")?.withRenderingMode(.alwaysTemplate), color: .lightClear)
    var title = UILabel(font: .text_14_m, color: .lightClear, alignment: .left, numOfLines: 1)
    var searchBtn = IconBtn(image: UIImage(named: "search"), color: .lightClear)
    var moreBtn = IconBtn(image: UIImage(named: "more"), color: .blade)
    
    var gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.clear.cgColor]
        layer.locations = [0.0 , 1.0]
        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)
        return layer
    }()

    var isScrolled: Bool = false {
        didSet {
            setupRightButton()
        }
    }

    var username: String = "" {
        didSet {
            setupTitle()
        }
    }

    init() {
        super.init(frame: .zero)

        setupStack()
        setupGradient()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame.size = frame.size
    }

    func setupStack() {
        axis = .horizontal
        alignment = .center

        addMargins(top: 0, left: 10, bottm: 9, right: 10)
        addArrangedSubviews([backBtn, title, searchBtn, moreBtn])

        setupRightButton()
    }

    func setupWithColor(_ color: UIColor) {
        backBtn.imageView?.tintColor = color
        title.textColor = color
        gradientLayer.removeFromSuperlayer()
    }

    func setupGradient() {
        gradientLayer.removeFromSuperlayer()
        layer.insertSublayer(gradientLayer, at: 0)
    }

    private func setupRightButton() {
        searchBtn.isHidden = isScrolled
        moreBtn.isHidden = !isScrolled
    }

    private func setupTitle() {
        title.text = username
    }

    private func normalizedUsername(original: String) -> String {
        guard String(original.dropFirst()) != "@" else { return original }

        return "@".appending(original)
    }
}
