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
    func showError(title: String?, message: String)
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
            getSong()
        }
        
        contentView.tapCopyButtonAction = { [unowned self] in
            presenter.pasteTextFromBuffer()
        }
    }
    
}

// MARK: - Private Methods

private extension LinkView {
    
    func getSong() {
        guard let songUrlString = contentView.linkTextField.text, songUrlString != "" else { return }
        
        presenter.getSong(urlString: songUrlString)
    }
    
}


// MARK: - UITextFieldDelegate

extension LinkView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getSong()
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        contentView.enableSearchButton(string.count > 0 || range.location > 0)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        contentView.enableSearchButton(false)
        
        return true
    }
    
}

// MARK: - LinkViewProtocol

extension LinkView: LinkViewProtocol {
    
    func setLink(_ linkString: String) {
        contentView.setLinkText(linkString)
        contentView.enableSearchButton(true)
        
        getSong()
    }
    
    func setLinkTitle(_ title: String) {
        contentView.setCopyButtonTitle(title)
    }
    
    func hideSetLink(_ hidden: Bool) {
        contentView.linkTextField.inputAccessoryView?.isHidden = hidden
    }
    
    func showError(title: String?, message: String) {
        showAlert(title: title, message: message)
    }
    
}
