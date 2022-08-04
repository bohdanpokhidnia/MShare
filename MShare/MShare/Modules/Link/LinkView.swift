//
//  LinkView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol LinkViewProtocol: AnyObject {
    var presenter: LinkPresenterProtocol? { get set }
    var viewController: UIViewController { get }
    
    func setLink(_ linkString: String)
    func setServiceItems(_ items: [MediaItem])
}

class LinkView: ViewController<LinkContentView> {
    
    var presenter: LinkPresenterProtocol?
    var viewController: UIViewController {
        return self
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupNavigationBar()
        setupActionHandlers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter?.viewDidAppear()
    }
    
    // MARK: - Private
    
    private var serviceItems = [MediaItem]()

}

// MARK: - Setup

private extension LinkView {
    
    func setupViews() {
        contentView.linkTextField.delegate = self
        contentView.servicesTableView.tableView.dataSource = self
        contentView.servicesTableView.tableView.delegate = self
    }
    
    func setupNavigationBar() {
        title = "Link"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupActionHandlers() {
        contentView.searchButton.whenTap { [unowned self] in
            presenter?.getServices()
        }
    }
    
}

// MARK: - UICollectionViewDataSource

extension LinkView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serviceItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sericeItem = serviceItems[indexPath.row]
        
        let cell = tableView.dequeue(MediaTableViewCell.self, for: indexPath)
        return cell
            .set(state: sericeItem)
            .accessoryType(.disclosureIndicator)
    }
    
}

// MARK: - UICollectionViewDelegate

extension LinkView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        presenter?.showSongList(at: indexPath)
    }
    
}

// MARK: - UITextFieldDelegate

extension LinkView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}

// MARK: - LinkViewProtocol

extension LinkView: LinkViewProtocol {
    
    func setLink(_ linkString: String) {
        contentView.setLinkText(linkString)
    }
    
    func setServiceItems(_ items: [MediaItem]) {
        serviceItems.removeAll()
        serviceItems = items
        
        contentView.servicesTableView.tableView.reloadData()
    }
    
}
