//
//  FirstFavoritesView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 03.11.2022.
//

import UIKit

protocol FirstFavoritesDelegate: AnyObject {
    func didSelectFavoritesSection(_ sectionIndex: Int)
}

final class FirstFavoritesView: UIViewController {
    weak var delegate: FirstFavoritesDelegate?
    
    var favoriteSectionIndex: Int = 0 {
        didSet {
            selectedIndexPath = IndexPath(row: favoriteSectionIndex, section: 0)
        }
    }
    
    // MARK: - UI
    
    private(set) lazy var favoritSectionTableView = TableView(style: .insetGrouped)
        .register(class: SettingsTableViewCell.self)
        .make {
            $0.dataSource = self
            $0.delegate = self
            $0.isScrollEnabled = false
        }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSubviews()
        defineLayout()
    }
    
    // MARK: - Private
    
    private var selectedIndexPath = IndexPath(row: 0, section: 0)
}

// MARK: - Setup

private extension FirstFavoritesView {
    func setupNavigationBar() {
        title = "First Favorites"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupSubviews() {
        view.addSubview(favoritSectionTableView)
    }
    
    func defineLayout() {
        favoritSectionTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

// MARK: - UITableViewDataSource

extension FirstFavoritesView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoritesView.FavoriteSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = FavoritesView.FavoriteSection.allCases[indexPath.row]
        let accessoryType: UITableViewCell.AccessoryType = selectedIndexPath == indexPath ? .checkmark : .none
        let cell = tableView.dequeue(SettingsTableViewCell.self, for: indexPath)
        return cell
            .set(state: SettingsEntity(
                title: section.title,
                image: nil,
                accessoryType: nil
            ))
            .make {
                $0.accessoryType = accessoryType
            }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select first section"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "This category will display like first in favorites"
    }
}

// MARK: - UITableViewDelegate

extension FirstFavoritesView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard selectedIndexPath != indexPath else { return }
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = .checkmark
        selectedIndexPath = indexPath
        delegate?.didSelectFavoritesSection(indexPath.row)
        tableView.reloadData()
    }
}
