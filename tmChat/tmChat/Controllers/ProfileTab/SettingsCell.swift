//
//  SettingsCell.swift
//  tmchat
//
//  Created by Farid Guliev on 21.08.2023.
//

import UIKit
import EasyPeasy
import Kingfisher

final class SettingsCell: UITableViewCell {

    // MARK: - Types

    enum Icon {
        case image(UIImage?)
        case avatar(URL?, colorCode: String)
    }

    enum ContentSize {
        case large
        case medium

        var titleFont: UIFont? {
            switch self {
            case .large: return .tab_label
            case .medium: return .bold(size: 14)
            }
        }

        var subtitleFont: UIFont? {
            switch self {
            case .large: return .regular(size: 14)
            case .medium: return .regular(size: 12)
            }
        }

        var iconSize: CGFloat {
            switch self {
            case .large: return 44
            case .medium: return 40
            }
        }
    }

    enum RightButtonMode {
        case share
    }

    struct Model {

        var icon: Icon
        var size: ContentSize = .large
        var title: String?
        var subtitle: String?
        var rightButtonMode: RightButtonMode?
        var backgroundColor = UIColor.clear
        var padding: UIEdgeInsets
        var contentInsets = UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6)
        var borderColor: UIColor?
        var tapCallback: (() -> ())?
        var buttonCallback: (() -> ())?
    }

    // MARK: - Public Properties

    static let id = "SettingsCell"

    var model: Model? {
        didSet {
            reloadData()
            setNeedsUpdateConstraints()
            updateConstraintsIfNeeded()
        }
    }

    // MARK: - Private Properties

    private let contentStack = UIStackView(axis: .horizontal, alignment: .fill, spacing: 14, edgeInsets: .init(edges: 14))
    private let labelsStack = UIStackView(axis: .vertical, alignment: .leading, spacing: 2)
    private let iconImageView = UIImageView(contentMode: .center, cornerRadius: .zero, backgroundColor: .onBg1)
    private let titleLabel = UILabel(font: .tab_label, numOfLines: 1)
    private let subtitleLabel = UILabel(font: .regular(size: 14), color: .latina_metis, numOfLines: 1)

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .clear
        selectionStyle = .none
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Public Methods

    override func prepareForReuse() {
        super.prepareForReuse()

        iconImageView.image = nil
        contentStack.layer.borderWidth = .zero
    }

    override func updateConstraints() {
        super.updateConstraints()

        contentStack.easy.clear()
        contentStack.easy.layout(Edges(model?.padding ?? .zero))

        let size = model?.size ?? .large
        iconImageView.easy.clear()
        iconImageView.easy.layout(Size(size.iconSize))
        iconImageView.layer.cornerRadius = size.iconSize / 2.0
    }

    func setupViews() {
        contentView.addSubview(contentStack)

        contentStack.addArrangedSubviews([iconImageView, labelsStack])
        contentStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
        contentStack.layer.cornerRadius = 10
        contentStack.isLayoutMarginsRelativeArrangement = true

        labelsStack.addArrangedSubviews([titleLabel, subtitleLabel])

        contentStack.easy.layout(Edges())
        iconImageView.easy.layout(Size(ContentSize.large.iconSize))
    }

    // MARK: - Private Methods

    private func reloadData() {
        guard let model else { return }

        titleLabel.text = model.title
        titleLabel.isHidden = (model.title ?? "").isEmpty
        titleLabel.font = model.size.titleFont
        subtitleLabel.text = model.subtitle
        subtitleLabel.font = model.size.subtitleFont
        contentStack.backgroundColor = model.backgroundColor
        contentStack.layoutMargins = model.contentInsets

        switch model.icon {
        case let .image(image):
            iconImageView.image = image?.withRenderingMode(.alwaysTemplate)
            iconImageView.contentMode = .center
            iconImageView.tintColor = .blade
            iconImageView.backgroundColor = .onBg1
        case let .avatar(url, colorCode):
            iconImageView.kf.setImage(with: url)
            iconImageView.contentMode = .scaleAspectFill
            iconImageView.backgroundColor = UIColor(hexString: colorCode)
        }
        if let borderColor = model.borderColor {
            contentStack.layer.borderWidth = 1
            contentStack.layer.borderColor = borderColor.cgColor
        }
    }

    @objc
    private func onTap() {
        model?.tapCallback?()
    }
}
