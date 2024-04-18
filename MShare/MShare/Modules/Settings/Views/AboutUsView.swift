//
//  AboutUsView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 23.10.2022.
//

import UIKit

final class AboutUsView: UIViewController {
    struct AboutItem {
        let name: String
        let role: String
        let avatar: UIImage?
        let instagramUserName: String
        let instagramLink: String
    }
    
    // MARK: - UI
    
    private(set) lazy var developersTableView = TableView(style: .insetGrouped)
        .make {
            $0.dataSource = self
            $0.delegate = self
            $0.register(class: DeveloperTableViewCell.self)
            $0.rowHeight = 60
            $0.isScrollEnabled = false
        }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
        defineLayout()
    }
    
    // MARK: - Private
    
    private let aboutItems: [AboutItem] = [
        AboutItem(
            name: "Bohdan Pokhidnia",
            role: "iOS developer",
            avatar: .bohdanAvatar,
            instagramUserName: "@bohdan.pokhidnia",
            instagramLink: "https://www.instagram.com/bohdan.pokhidnia"
        ),
        AboutItem(
            name: "Petro Kopyl",
            role: "Back-end developer",
            avatar: .petroAvatar,
            instagramUserName: "@petro_kopyl",
            instagramLink: "https://www.instagram.com/petro_kopyl/"
        ),
    ]
}

// MARK: - Setup

private extension AboutUsView {
    func setupNavigationBar() {
        title = "About"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupViews() {
        view.addSubview(developersTableView)
    }
    
    func defineLayout() {
        developersTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource

extension AboutUsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aboutItems.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Our team"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = aboutItems[indexPath.row]
        let cell = tableView.dequeue(DeveloperTableViewCell.self, for: indexPath)
        return cell.set(state: .init(name: item.name, role: item.role, avatar: item.avatar))
    }
}

// MARK: - UITableViewDelegate

extension AboutUsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let aboutItem = aboutItems[indexPath.row]
        didTapOpenInstagram(for: aboutItem)
    }
}

// MARK: - Private Methods

private extension AboutUsView {
    func didTapOpenInstagram(for item: AboutItem) {
        guard let url = URL(string: item.instagramLink) else {
            return
        }
        
        UIApplication.shared.open(url)
    }
}
