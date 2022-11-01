//
//  FavoritesView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 15.10.2022.
//

import UIKit

protocol FavoritesViewProtocol: AnyObject {
    var presenter: FavoritesPresenterProtocol? { get set }
    var viewController: UIViewController { get }
    
    func showError(_ error: Error)
    func reloadData()
    func deleteRow(forIndexPath indexPath: IndexPath)
}

final class FavoritesView: ViewController<FavoritesContentView> {
    
    enum FavoriteSection: Int, CaseIterable {
        case song
        case album

        var title: String {
            switch self {
            case .song:
                return "Songs"

            case .album:
                return "Albums"
            }
        }
        
        var mediaType: MediaType {
            switch self {
            case .song:
                return .song
                
            case .album:
                return .album
            }
        }
    }
    
    var presenter: FavoritesPresenterProtocol?
    
    var viewController: UIViewController {
        return self
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.viewWillAppear()
    }

}

// MARK: - Setup

private extension FavoritesView {
    
    func setupNavigationBar() {
        title = "Favorites"
    }
    
    func setupSubviews() {
        contentView.favotitesTableView.make {
            $0.dataSource = self
            $0.delegate = self
        }
    }

}

// MARK: - UITableViewDataSource

extension FavoritesView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let count = presenter?.mediaSectionsCount() else { return 0 }
        return count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let favoriteSection = FavoriteSection(rawValue: section),
              let count = presenter?.mediaCount(by: favoriteSection.mediaType)
        else { return 0 }

        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let mediaItem = presenter?.metdiaItem(forIndexPath: indexPath) else { return UITableViewCell() }
        let cell = tableView.dequeue(MediaTableViewCell.self, for: indexPath)
        
        return cell
            .set(delegate: self, indexPath: indexPath)
            .set(state: mediaItem)
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let favoriteSection = FavoriteSection(rawValue: section)
        return favoriteSection?.title
    }
    
}

// MARK: - UITableViewDelegate

extension FavoritesView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trashAction = UIContextualAction(style: .destructive, title: "") { [weak presenter] (action, view, completionHandler) in
            presenter?.removeMediaItem(forIndexPath: indexPath)
            
            completionHandler(true)
        }
        trashAction.image = UIImage(systemName: "trash")
        
        let configuration = UISwipeActionsConfiguration(actions: [trashAction])
        return configuration
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter?.tapOnMediaItem(forIndexPath: indexPath)
    }
    
}

// MARK: - MediaItemDelegate

extension FavoritesView: MediaItemDelegate {
    
    func didTapShareButton(_ indexPath: IndexPath) {
        presenter?.shareUrl(forIndexPath: indexPath)
    }
    
}

// MARK: - FavoritesViewProtocol

extension FavoritesView: FavoritesViewProtocol {
    
    func showError(_ error: Error) {
        showAlert(title: "Error",
                  message: error.localizedDescription,
                  alertAction: nil)
    }
    
    func reloadData() {
        contentView.favotitesTableView.reloadData()
    }
    
    func deleteRow(forIndexPath indexPath: IndexPath) {
        contentView.favotitesTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
}
