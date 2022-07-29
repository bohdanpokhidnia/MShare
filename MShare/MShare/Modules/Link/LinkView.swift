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
}

class LinkView: ViewController<LinkContentView> {
    
    var presenter: LinkPresenterProtocol?
    var viewController: UIViewController {
        return self
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupUserActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presenter?.setupPresenter()
    }

}

// MARK: - Setup

private extension LinkView {
    
    func setupNavigationBar() {
        title = "Link"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}

// MARK: - User interactions

private extension LinkView {
    
    func setupUserActions() {
        contentView.searchOnLinkAction = {
            print("[dev] clicked on link search button")
        }
    }
    
}

// MARK: - LinkViewProtocol

extension LinkView: LinkViewProtocol {
    
    func setLink(_ linkString: String) {
        contentView.linkTextField.text = linkString
    }
    
}
