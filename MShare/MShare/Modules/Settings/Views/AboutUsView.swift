//
//  AboutUsView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 23.10.2022.
//

import UIKit

final class AboutUsView: UIViewController {
    
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(DeveloperTableViewCell.self, for: indexPath)
        return cell.set(state: .init(name: "Bohdan Pokhidnia",
                                     avatar: nil,
                                     instagram: .init(name: "@bohdan.pokhidnia",
                                                      link: "https://www.instagram.com/bohdan.pokhidnia")))
    }
    
}
