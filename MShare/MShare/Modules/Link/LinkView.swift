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
    func setLinkTitle(_ title: String)
    func hideSetLink(_ hidden: Bool)
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
    }
    
    func setupNavigationBar() {
        title = "Link"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupActionHandlers() {
        contentView.searchButton.whenTap { [unowned self] in
            presenter.getSong(urlString: "some link from text field")
        }
        
        contentView.tapCopyButtonAction = { [unowned self] in
            presenter.pasteTextFromBuffer()
        }
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
    
    func setLinkTitle(_ title: String) {
        contentView.setCopyButtonTitle(title)
    }
    
    func hideSetLink(_ hidden: Bool) {
        contentView.linkTextField.inputAccessoryView?.isHidden = hidden
    }
    
}
