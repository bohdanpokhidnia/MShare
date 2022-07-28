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
        setupUserInteraction()
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
    
    func setupUserInteraction() {
        contentView.searchOnLinkAction = {
            print("[dev] clicked on link search button")
        }
    }
    
}

// MARK: - LinkViewProtocol

extension LinkView: LinkViewProtocol {
    
}
