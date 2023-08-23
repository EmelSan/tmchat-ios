//
//  AppSettingsVC.swift
//  tmchat
//
//  Created by Farid Guliev on 22.08.2023.
//

import UIKit
import EasyPeasy

final class AppSettingsVC: UIViewController {

    // MARK: - Types

    private typealias Row = SettingsCell

    // MARK: - Private Methods

    private let header = Header(title: "app_settings".localized())

    private let tableView: UITableView = {
        let table = UITableView(rowHeight: UITableView.automaticDimension, estimatedRowHeight: 68, backgroundColor: .bg)
        table.register(Row.self, forCellReuseIdentifier: Row.id)
        return table
    }()

    private var sheetTransitioningDelegate = SheetTransitioningDelegate()

    private lazy var rows: [Row.Model] = [
//        .init(icon: .image(UIImage(named: "alert")),
//              size: .medium,
//              title: "notifications".localized(),
//              subtitle: "notifications_description".localized(),
//              padding: .init(top: 10, left: 14, bottom: 4, right: 14),
//              contentInsets: .init(horizontalEdges: 6, verticalEdges: 8),
//              tapCallback: openNotifications),
//        .init(icon: .image(UIImage(named: "lock")),
//              size: .medium,
//              title: "privacy".localized(),
//              subtitle: "privacy_description".localized(),
//              padding: .init(top: 0, left: 14, bottom: 4, right: 14),
//              contentInsets: .init(horizontalEdges: 6, verticalEdges: 8),
//              tapCallback: openPrivacy),
//        .init(icon: .image(UIImage(named: "device")),
//              size: .medium,
//              title: "devices".localized(),
//              subtitle: "devices_description".localized(),
//              padding: .init(top: 0, left: 14, bottom: 4, right: 14),
//              contentInsets: .init(horizontalEdges: 6, verticalEdges: 8),
//              tapCallback: openDevices),
        .init(icon: .image(UIImage(named: "local-language")),
              size: .medium,
              title: "language".localized(),
              subtitle: "language_description".localized(),
              padding: .init(top: 0, left: 14, bottom: 4, right: 14),
              contentInsets: .init(horizontalEdges: 6, verticalEdges: 8),
              tapCallback: openLanguage),
    ]

    private var isInitialLoad = true

    private var userID: String {
        AccUserDefaults.id
    }

    // MARK: - Init

    init() {
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
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.addSubview(header)
        view.addSubview(tableView)

        header.backgroundColor = .lightClear

        header.easy.layout([
            Top(), Leading(), Trailing(),
        ])
        tableView.easy.layout([
            Top().to(header, .bottom),
            Bottom(),
            Leading(), Trailing()
        ])
    }

    private func bind() {
        header.backBtn.clickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    private func openNotifications() {
        let vc = NotificationsVC()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func openPrivacy() {
        
    }

    private func openDevices() {

    }

    private func openLanguage() {
        let vc = SelectLangBS()
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = sheetTransitioningDelegate

        vc.langClickCallback = { [weak self] lang in
            vc.dismiss(animated: true) {
                self?.tableView.reloadData()

                guard let vc = self?.navigationController?.viewControllers.first as? TabbarController else { return }

                vc.setupVc()
            }
        }
        present(vc, animated: true)
    }
}

extension AppSettingsVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Row.id, for: indexPath) as! Row
        cell.model = rows[indexPath.row]

        return cell
    }
}

