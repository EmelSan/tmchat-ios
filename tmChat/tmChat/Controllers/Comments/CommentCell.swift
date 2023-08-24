//
//  CommentCell.swift
//  tmchat
//
//  Created by Farid Guliev on 23.08.2023.
//

import UIKit
import EasyPeasy
import Kingfisher

final class CommentCell: UITableViewCell {

    // MARK: - Types

    private enum Const {
        static let avatarSize = 30.0
    }

    struct Model {

        var commenterAvatarURL: URL
        var colorCode: String
        var commenterName: String?
        var commentDate: Date?
        var comment: String
        var isMyComment: Bool
    }

    enum Action {
        case complainTap
    }

    // MARK: - Public Properties

    static let id = "CommentCell"

    var model: Model? {
        didSet {
            reloadData()
            layoutIfNeeded()
        }
    }

    var onAction: Closure<Action>?

    // MARK: - Private Properties

    private let contentStack = UIStackView(axis: .vertical,
                                           alignment: .fill,
                                           spacing: 10,
                                           edgeInsets: .init(edges: 14),
                                           backgroundColor: .lightClear)
    private let topStack = UIStackView(axis: .horizontal, spacing: 10)
    private let labelsStack = UIStackView(axis: .vertical, alignment: .leading, spacing: 2)
    private let avatarImageView = UIImageView(contentMode: .scaleAspectFill, cornerRadius: Const.avatarSize / 2.0)
    private let titleLabel = UILabel(font: .tab_label, numOfLines: 1)
    private let subtitleLabel = UILabel(font: .regular(size: 14), color: .latina_metis, numOfLines: 1)
    private let complainButton = IconBtn(image: UIImage(named: "warning"), color: .lee)
    private let commentLabel = UILabel(font: .regular(size: 14))

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

        avatarImageView.image = nil
    }

    // MARK: - Private Methods

    private func setupViews() {
        contentView.addSubview(contentStack)

        contentStack.addArrangedSubviews([topStack, commentLabel])
        topStack.addArrangedSubviews([avatarImageView, labelsStack, UIView(), complainButton])
        labelsStack.addArrangedSubviews([titleLabel, subtitleLabel])

        contentStack.easy.layout(Leading(), Top(), Trailing(), Bottom(10))
        avatarImageView.easy.layout(Size(Const.avatarSize))
    }

    private func bind() {
        complainButton.clickCallback = { [weak self] in
            self?.onAction?(.complainTap)
        }
    }

    private func reloadData() {
        guard let model else { return }

        titleLabel.text = model.commenterName
        subtitleLabel.text = model.commentDate?.getTime()

        complainButton.isHidden = model.isMyComment

        avatarImageView.kf.setImage(with: model.commenterAvatarURL)
        avatarImageView.backgroundColor = UIColor(hexString: model.colorCode)
        commentLabel.text = model.comment
    }
}
