//
//  CallSnackbar.swift
//  tmchat
//
//  Created by Farid Guliev on 22.08.2023.
//

import UIKit
import EasyPeasy

final class CallSnackbar: UIView {

    // MARK: - Types

    struct Model {

        let userName: String
        let avatarURL: URL?
        let colorCode: String?
    }

    // MARK: - Public Properties

    var model: Model? {
        didSet {
            reloadData()
        }
    }

    // MARK: - Private Properties

    private let contentStack = UIStackView(axis: .horizontal,
                                           alignment: .center,
                                           spacing: 10,
                                           edgeInsets: .init(horizontalEdges: 18, verticalEdges: 20),
                                           backgroundColor: .blade,
                                           cornerRadius: 14)

    private let avatarImageView = UIImageView(contentMode: .scaleAspectFill, cornerRadius: 20)
    private let labelsStack = UIStackView(axis: .vertical, spacing: 1)
    private let buttonsStack = UIStackView(axis: .horizontal, spacing: 20)

    private let nameLabel = UILabel(font: .semibold(size: 14), color: .lightClear, numOfLines: 1)
    private let subtitleLabel = UILabel(font: .regular(size: 14), color: .lee, numOfLines: 1, text: "incoming_call".localized())
    private let dismissButton = IconBtn(image: UIImage(named: "call-dismiss"), color: .lightClear)
    private let answerButton = IconBtn(image: UIImage(named: "call-answer"), color: .lightClear)

    // MARK: - Init

    init() {
        super.init(frame: .zero)

        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Public Methods

    func show(on view: UIView, onAnswer: @escaping VoidClosure, onDismiss: @escaping VoidClosure) {
        hide()
        view.addSubview(self)
        SoundPlayer.shared.startRingtone()

        easy.layout([
            Leading(10), Top(10).to(view.safeAreaLayoutGuide, .top), Trailing(10)
        ])
        answerButton.clickCallback = onAnswer
        dismissButton.clickCallback = onDismiss
    }

    func hide() {
        SoundPlayer.shared.stopRingtone()
        removeFromSuperview()
    }

    // MARK: - Private Methods

    private func setupViews() {
        addSubview(contentStack)
        contentStack.easy.layout(Edges())

        contentStack.addArrangedSubviews([avatarImageView, labelsStack, buttonsStack])
        labelsStack.addArrangedSubviews([nameLabel, subtitleLabel])
        buttonsStack.addArrangedSubviews([dismissButton, answerButton])

        avatarImageView.easy.layout(Size(40))

        dismissButton.backgroundColor = .alert
        dismissButton.layer.cornerRadius = 20

        answerButton.backgroundColor = .greenWeed
        answerButton.layer.cornerRadius = 20
    }

    private func reloadData() {
        guard let model else { return }

        nameLabel.text = model.userName
        avatarImageView.kf.setImage(with: model.avatarURL)
        avatarImageView.backgroundColor = UIColor(hexString: model.colorCode ?? "#A5A5A5")
    }
}
