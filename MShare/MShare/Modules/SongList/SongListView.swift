//
//  SongListView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 04.08.2022.
//

import UIKit

protocol SongListViewProtocol: AnyObject {
    var presenter: SongListPresenterProtocol { get set }
    var viewController: UIViewController { get }
    
    func reloadData()
}

class SongListView: ViewController<SongListContentView> {
    
    var presenter: SongListPresenterProtocol
    var viewController: UIViewController {
        return self
    }
    
    // MARK: - Initializers
    
    init(presenter: SongListPresenterProtocol) {
        self.presenter = presenter
        
        super.init()
    }
    
    @available(*, unavailable)
    required init() {
        fatalError("init() has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
        presenter.viewDidLoad()
    }

}

// MARK: - Setup

extension SongListView {
    
    func setupNavigationBar() {
        title = "Songs"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func setupViews() {
        contentView.songsTableView.tableView.dataSource = self
        contentView.songsTableView.tableView.delegate = self
    }
    
}

// MARK: - UITableViewDataSource

extension SongListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let song = presenter.itemForRow(at: indexPath)
        let cell = tableView.dequeue(MediaTableViewCell.self, for: indexPath)
        
        return cell
            .set(state: song)
            .set(delegate: self, indexPath: indexPath)
            .accessoryType(.disclosureIndicator)
    }
    
}

// MARK: - UITableViewDelegate

extension SongListView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - MediaItemDelegate

extension SongListView: MediaItemDelegate {
    
    func didTapShareButton(_ indexPath: IndexPath) {
        presenter.shareSong(at: indexPath)
    }
    
}

// MARK: - SongListViewProtocol

extension SongListView: SongListViewProtocol {
    
    func reloadData() {
        contentView.songsTableView.tableView.reloadData()
    }
    
}
