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
    func setupFavoriteSection(_ sectionIndex: Int)
    func setEmptyInfoText(_ text: String)
    func displayEmptyInfo(_ show: Bool)
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
        
        var emptyText: String {
            switch self {
            case .song:
                return "You haven't added any songs yet"
                
            case .album:
                return "You haven't added any albums yet"
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
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.viewWillAppear()
    }
    
    // MARK: - Private
    
    private var selectedItem: IndexPath?

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
        
        contentView.segmentedControl.didSelectItemWith = { [weak presenter] (index, _) in
            presenter?.didSelectSection(index)
        }
    }

}

// MARK: - UITableViewDataSource

extension FavoritesView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.mediaCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let mediaItem = presenter?.metdiaItem(forIndexPath: indexPath) else { return UITableViewCell() }
        let cell = tableView.dequeue(MediaTableViewCell.self, for: indexPath)
        
        return cell
            .set(delegate: self, indexPath: indexPath)
            .set(state: mediaItem)
        
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
        selectedItem = indexPath

        presenter?.tapOnMediaItem(forIndexPath: indexPath)
    }
    
}

// MARK: - MediaItemDelegate

extension FavoritesView: MediaItemDelegate {
    
    func didTapShareButton(_ indexPath: IndexPath) {
        presenter?.shareUrl(forIndexPath: indexPath)
    }
    
}

//MARK: - TransitionProtocol

extension FavoritesView: TransitionProtocol {
    
    var transitionView: UIView {
        return view
    }
    
    func viewsToAnimate() -> [UIView] {
        guard let selectedItem else { fatalError("without selected index path") }
        let cell = contentView.favotitesTableView.cellForRow(MediaTableViewCell.self, at: selectedItem)
        let coverImage = cell.iconImageView
        
        return [coverImage]
    }
    
    func copyForView(_ subView: UIView) -> UIView {
        guard let selectedIndexPath = contentView.favotitesTableView.indexPathForSelectedRow else { fatalError("without \(subView)") }
        let cell = contentView.favotitesTableView.cellForRow(MediaTableViewCell.self, at: selectedIndexPath)
        
        guard subView == cell.iconImageView else { fatalError("other view, don't found \(subView)") }
        let copyImageView = UIImageView(image: cell.iconImageView.image)
            .setCornerRadius(12)
            .maskToBounds(true)
        return copyImageView
    }
    
}

// MARK: - FavoritesViewProtocol

extension FavoritesView: FavoritesViewProtocol {
    
    func showError(_ error: Error) {
        showAlert(
            title: "Error",
            message: error.localizedDescription,
            alertAction: nil
        )
    }
    
    func reloadData() {
        contentView.favotitesTableView.reloadData()
    }
    
    func deleteRow(forIndexPath indexPath: IndexPath) {
        contentView.favotitesTableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func setupFavoriteSection(_ sectionIndex: Int) {
        contentView.segmentedControl.selectItemAt(index: sectionIndex)
        reloadData()
    }
    
    func setEmptyInfoText(_ text: String) {
        contentView.set(infoText: text)
    }
    
    func displayEmptyInfo(_ show: Bool) {
        contentView.showEmptyInfo(show)
    }
    
}
