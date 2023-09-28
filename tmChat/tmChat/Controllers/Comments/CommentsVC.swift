//
//  CommentsVC.swift
//  tmchat
//
//  Created by Farid Guliev on 23.08.2023.
//

import UIKit
import EasyPeasy

final class CommentsVC: UIViewController {

    // MARK: - Types

    private typealias Row = CommentCell

    // MARK: - Private Methods

    private let header = Header(title: "comments_title".localized())

    private let tableView: UITableView = {
        let table = UITableView(rowHeight: UITableView.automaticDimension, estimatedRowHeight: 100, backgroundColor: .clear)
        table.register(Row.self, forCellReuseIdentifier: Row.id)
        table.keyboardDismissMode = .onDrag
        return table
    }()

    private let emptyLabel = UILabel(font: .regular(size: 16),
                                     color: .lee,
                                     alignment: .center,
                                     numOfLines: 1,
                                     text: "empty_comments".localized())

    private let textField: MessagingTextField = {
        let field = MessagingTextField()
        field.placeholderText = "comment_placeholder".localized()
        field.canSendAttachment = false
        return field
    }()

    private let postUUID: String
    private var comments: [PostComment]

    private var userID: String {
        AccUserDefaults.id
    }

    // MARK: - Init

    init(postUUID: String, comments: [PostComment]) {
        self.postUUID = postUUID
        self.comments = comments

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self

        setupViews()
        bind()
        reloadData()
        observeKeyboard()

        if comments.isEmpty {
            loadData()
        }
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.backgroundColor = .bg
        view.addSubview(header)
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        view.addSubview(textField)

        header.easy.layout(Leading(), Top(), Trailing())
        tableView.easy.layout([
            Top().to(header, .bottom),
            Bottom().to(textField, .top),
            Leading(), Trailing()
        ])
        textField.easy.layout(Leading(), Trailing(), Bottom())
        emptyLabel.easy.layout(Leading(), Trailing(), CenterY())

        header.backgroundColor = .lightClear
    }

    private func bind() {
        textField.sendBtn.clickCallback = { [weak self] in
            self?.sendComment()
        }
        header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    private func loadData() {
        FeedRequests.shared.getComments(uuid: postUUID) { [weak self] response in
            guard let comments = response?.data else { return }

            self?.comments = comments
            self?.reloadData()
        }
    }

    private func reloadData() {
        if comments.isEmpty {
            tableView.isHidden = true
            emptyLabel.isHidden = false
        } else {
            tableView.isHidden = false
            emptyLabel.isHidden = true
            tableView.reloadData()
        }
    }

    private func sendComment() {
        guard let comment = textField.textView.text, !comment.isEmpty else { return }

        textField.setText(nil)

        FeedRequests.shared.addComment(uuid: postUUID, comment: comment) { [weak self] response in
            guard let comments = response?.data else { return }

            self?.comments = comments
            self?.reloadData()
        }
    }

    private func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardRectangle = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let keyboardHeight = keyboardRectangle.size.height - DeviceDimensions.bottomInset
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double

        DispatchQueue.main.async {
            self.textField.easy.layout(Bottom(keyboardHeight).to(self.view.safeAreaLayoutGuide, .bottom))

            UIView.animate(withDuration: duration) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        textField.easy.layout(Bottom().to(view.safeAreaLayoutGuide, .bottom))

        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension CommentsVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Row.id, for: indexPath) as! Row
        let comment = comments[indexPath.row]

        cell.model = .init(commenterAvatarURL: ApiPath.url(comment.commenter?.avatar ?? ""),
                           colorCode: comment.commenter?.colorCode ?? "#A5A5A5",
                           commenterName: comment.commenter?.fullName ?? comment.commenter?.username,
                           commentDate: nil,
                           comment: comment.comment ?? "",
                           isMyComment: comment.commenterId == userID)

        cell.onAction = { [weak self] action in
            switch action {
            case .complainTap:
                #warning("handle")
                break
            }
        }
        return cell
    }
}

