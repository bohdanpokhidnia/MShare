//
//  SearchView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol SearchViewProtocol: AnyObject {
    var presenter: SearchPresenterProtocol? { get set }
    var viewController: UIViewController { get }
}

class SearchView: ViewController<SearchContentView> {
    
    var presenter: SearchPresenterProtocol?
    var viewController: UIViewController {
        return self
    }
    
    // MARK: - UI
    
    private lazy var searchController = UISearchController()
        .make {
            $0.searchResultsUpdater = self
            $0.searchBar.delegate = self
            $0.searchBar.image(for: .resultsList, state: .selected)
            $0.searchBar.scopeButtonTitles = ["Apple Music", "Spotify"]
        }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        contentView.backgroundColor = .purple
    }

}

// MARK: - Setup

private extension SearchView {
    
    func setupNavigationBar() {
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
    }
    
}

// MARK: - SearchViewProtocol

extension SearchView: SearchViewProtocol {
    
}

// MARK: - UISearchResultsUpdating

extension SearchView: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}

extension SearchView: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let text = searchController.searchBar.text, !text.isEmpty else {
            return
        }
        
        print("[dev] \(#function)")
        print("[dev] \(text)")
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("[dev] \(#function)")
        print("[dev] \(selectedScope)")
    }
    
}
