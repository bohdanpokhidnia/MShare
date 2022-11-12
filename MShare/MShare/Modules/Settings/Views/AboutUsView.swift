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
        let avatar: UIImage?
        let instagramUserName: String
        let instagramLink: String
    }
    
    // MARK: - UI
    
    private(set) lazy var developersTableView = TableView(style: .plain)
        .make {
            $0.register(class: DeveloperTableViewCell.self)
            $0.dataSource = self
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
    
    private let aboutItems: [AboutItem] = [.init(name: "Bohdan Pokhidnia",
                                                 avatar: UIImage(named: "bohdanAvatar"),
                                                 instagramUserName: "@bohdan.pokhidnia",
                                                 instagramLink: "https://www.instagram.com/bohdan.pokhidnia"),
                                           .init(name: "Petro Kopyl",
                                                 avatar: UIImage(named: "petroAvatar"),
                                                 instagramUserName: "@petia.kopyl",
                                                 instagramLink: "https://www.instagram.com/petia.kopyl/")]
    
}

// MARK: - Setup

private extension AboutUsView {
    
    func setupNavigationBar() {
        title = "About"
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(DeveloperTableViewCell.self, for: indexPath)
        let item = aboutItems[indexPath.row]
        
        return cell.set(state: .init(
            name: item.name,
            avatar: item.avatar,
            instagram: .init(name: item.instagramUserName, link: item.instagramLink)
        ))
    }
    
}
