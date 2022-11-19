//
//  SettingsView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol SettingsViewProtocol: FirstFavoritesDelegate {
    var presenter: SettingsPresenterProtocol? { get set }
    var viewController: UIViewController { get }
}

final class SettingsView: ViewController<SettingsContentView> {
    
    var presenter: SettingsPresenterProtocol?
    var viewController: UIViewController {
        return self
    }
    
    // MARK: - UI
    
    private(set) lazy var settingsTable = TableView(style: .insetGrouped)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
        presenter?.viewDidLoad()
    }
    
}

// MARK: - Setup

private extension SettingsView {
    
    func setupNavigationBar() {
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupViews() {
        contentView.settingsTableView.make {
            $0.dataSource = self
            $0.delegate = self
        }
    }
    
}

// MARK: - UITableViewDataSource

extension SettingsView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.settingsSectionCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let countOfSection = presenter?.settingsItemsCount(atSection: section)
        return countOfSection ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingsItem = presenter?.settingsItemStateInSection(atSection: indexPath.section, andIndex: indexPath.row)
        else { return UITableViewCell() }
        
        let cell = tableView.dequeue(SettingsTableViewCell.self, for: indexPath)
        return cell.set(state: .init(title: settingsItem.title,
                                     image: settingsItem.image,
                                     accesoryType: settingsItem.accesoryType))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = presenter?.settingsSectionTitle(atSection: section)
        return title
    }
    
}

// MARK: - UITableViewDelegate

extension SettingsView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter?.didTapSettingItem(atSection: indexPath.section, andIndex: indexPath.row)
    }
    
}

// MARK: - SettingsViewProtocol

extension SettingsView: SettingsViewProtocol {
    
    func didSelectFavoritesSection(_ sectionIndex: Int) {
        presenter?.didSelectFavoriteSection(sectionIndex)
    }
    
}
