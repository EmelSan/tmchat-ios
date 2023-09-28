//
//  TitleChevronView.swift
//  tmchat
//
//  Created by Farid Guliev on 20.08.2023.
//

import UIKit
import EasyPeasy

final class TitleChevronView: UIStackView {

    private var icon = UIImageView(contentMode: .scaleAspectFit,
                                   cornerRadius: 0,
                                   image: UIImage(named: "chevron"),
                                   backgroundColor: .clear)

    private var titleLabel = UILabel(font: .semibold(size: 14),
                                     color: .lee,
                                     numOfLines: 1)

    var title: String = "" {
        didSet {
            titleLabel.text = title
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

    func setupView(){
        icon.easy.layout(Size(20))
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)

        axis = .horizontal
        spacing = 4
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(horizontalEdges: 20, verticalEdges: 10)

        addArrangedSubviews([titleLabel, icon])
    }

    @objc
    private func click() {
        clickCallback?()
    }
}
