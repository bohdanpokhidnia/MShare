//
//  LinkView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol LinkViewProtocol: AnyObject {
    var presenter: LinkPresenterProtocol { get set }
    var viewController: UIViewController { get }
    
    func setLink(_ linkString: String)
    func setHeaderTitle(_ title: String)
    func reloadData()
}

final class LinkView: ViewController<LinkContentView> {
    
    var presenter: LinkPresenterProtocol
    
    var viewController: UIViewController {
        return self
    }
    
    // MARK: - Initializers
    
    init(presenter: LinkPresenterProtocol) {
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
        
        setupViews()
        setupNavigationBar()
        setupActionHandlers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter.viewDidAppear()
    }

}

// MARK: - Setup

private extension LinkView {
    
    func setupViews() {
        contentView.linkTextField.delegate = self
        
        contentView.servicesTableView.tableView.make {
            $0.dataSource = self
            $0.delegate = self
        }
    }
    
    func setupNavigationBar() {
        title = "Link"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupActionHandlers() {
        contentView.searchButton.whenTap { [unowned self] in
            presenter.getServices()
        }
    }
    
}

// MARK: - UICollectionViewDataSource

extension LinkView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sericeItem = presenter.itemForRow(at: indexPath)
        
        let cell = tableView.dequeue(MediaTableViewCell.self, for: indexPath)
        return cell
            .set(state: sericeItem)
            .accessoryType(.disclosureIndicator)
            .set(delegate: self, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withClass: ServiceHeaderView.self)
        
        return headerView
    }
    
}

// MARK: - UICollectionViewDelegate

extension LinkView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - UITextFieldDelegate

extension LinkView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}

// MARK: - MediaItemDelegate

extension LinkView: MediaItemDelegate {
    
    func didTapShareButton(_ indexPath: IndexPath) {
        presenter.getShareLink(at: indexPath)
    }
    
}

// MARK: - LinkViewProtocol

extension LinkView: LinkViewProtocol {
    
    func setLink(_ linkString: String) {
        contentView.setLinkText(linkString)
    }
    
    func setHeaderTitle(_ title: String) {
        let headerView = contentView.servicesTableView.tableView.headerView(forSection: 0) as? ServiceHeaderView
        
        headerView?.set(title)
    }
    
    func reloadData() {
        contentView.servicesTableView.tableView.reloadData()
    }
    
}
