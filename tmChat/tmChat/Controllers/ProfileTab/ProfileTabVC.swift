//
//  ProfileTabVC.swift
//  tmchat
//
//  Created by Farid Guliev on 21.08.2023.
//

import UIKit
import EasyPeasy

final class ProfileTabVC: UIViewController {

    // MARK: - Types

    private typealias Row = SettingsCell

    // MARK: - Private Methods

    private let tableView: UITableView = {
        let table = UITableView(rowHeight: UITableView.automaticDimension, estimatedRowHeight: 68, backgroundColor: .bg)
        table.register(Row.self, forCellReuseIdentifier: Row.id)
        return table
    }()

    private lazy var rows: [Row.Model] = [
        .init(icon: .image(UIImage(named: "settings")),
              title: "app_settings".localized(),
              subtitle: "app_settings_description".localized(),
              backgroundColor: .lightClear,
              padding: .init(top: 10, left: 20, bottom: 0, right: 20),
              contentInsets: .init(edges: 14),
              borderColor: .onBg1,
              tapCallback: openSettings),
        .init(icon: .image(UIImage(named: "people-search")),
              title: "contacts".localized(),
              subtitle: "contacts_description".localized(),
              padding: .init(top: 20, left: 14, bottom: 0, right: 14),
              tapCallback: openContactList),
//        .init(icon: .image(UIImage(named: "cloud")),
//              title: "my_cloud".localized(),
//              subtitle: "my_cloud_description".localized(),
//              padding: .init(top: 4, left: 14, bottom: 0, right: 14)),
//        .init(icon: .image(UIImage(named: "call")),
//              title: "calls".localized(),
//              subtitle: "calls_description".localized(),
//              padding: .init(top: 4, left: 14, bottom: 0, right: 14)),
        .init(icon: .image(UIImage(named: "question-circle")),
              title: "help".localized(),
              subtitle: "help_description".localized(),
              padding: .init(top: 4, left: 14, bottom: 0, right: 14)),
        .init(icon: .image(UIImage(named: "info2")),
              title: "\(App.name) v \(App.fullVersion)",
              subtitle: "app_description".localized(),
              padding: .init(top: 4, left: 14, bottom: 0, right: 14)),
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
        reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        reloadData()
    }

    // MARK: - Private Methods

    private func setupViews() {
        view.addSubview(tableView)

        tableView.easy.layout([
            Top(),
            Bottom().to(view.safeAreaLayoutGuide, .bottom),
            Leading(), Trailing()
        ])
    }

    private func reloadData() {
        UserRequests.shared.getUser(id: userID) { [weak self] response in
            guard let self, let user = response?.data else { return }

            var isReloading = false

            if !self.isInitialLoad {
                self.rows.removeFirst()
                isReloading = true
            }
            self.isInitialLoad = false

            self.rows.insert(.init(icon: .avatar(ApiPath.url(user.avatar ?? ""), colorCode: user.colorCode ?? "#A5A5A5"),
                                   title: user.fullName,
                                   subtitle: user.formattedUsername,
                                   rightButtonMode: .share,
                                   backgroundColor: .onBg1,
                                   padding: .init(top: 0, left: 20, bottom: 10, right: 20),
                                   contentInsets: .init(edges: 14),
                                   tapCallback: self.openProfile),
                             at: 0)

            if isReloading {
                self.tableView.reloadRows(at: [.init(row: 0, section: 0)], with: .automatic)
            } else {
                self.tableView.insertRows(at: [.init(row: 0, section: 0)], with: .automatic)
            }
        }
    }

    private func openProfile() {
        let vc = ProfileVC(type: .own)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func openSettings() {
        let vc = AppSettingsVC()
        navigationController?.pushViewController(vc, animated: true)
    }

    private func openContactList() {
        let vc = ContactListVC()
        vc.viewModel.params = PaginationParams(page: 1, id: userID)
        vc.mainView.header.title.text = "contact_list".localized()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ProfileTabVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Row.id, for: indexPath) as! Row
        cell.model = rows[indexPath.row]

        return cell
    }
}
