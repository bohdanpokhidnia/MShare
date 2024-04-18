//
//  SearchView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit
import SnapKit

protocol SearchViewProtocol: BaseView {
    var presenter: SearchPresenterProtocol? { get set }
    var viewController: UIViewController { get }
    
    func setLink(_ linkString: String)
    func setLinkTitle(_ title: String)
    func cleaningLinkTextField()
    func hideSetLink(_ hidden: Bool)
    func setOffsetLinkTextField(_ keyboardFrame: CGRect)
    func resetPositionLinkTextField()
    func showLoading()
    func hideLoading(completion: (() -> Void)?)
    func resetLinkTextFieldBorderColor(animated: Bool)
    func endEditing()
}

final class SearchView: ViewController<SearchContentView> {
    var presenter: SearchPresenterProtocol?
    var viewController: UIViewController { self }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.setTabBar(hidden: false, animated: false)
        presenter?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter?.viewWillDisappear()
    }
}

// MARK: - Setup

private extension SearchView {
    func setupNavigationBar() {
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupViews() {
        contentView.linkTextField.make {
            $0.delegate = self
            $0.addTarget(self, action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
        }
    }
    
    func setupActions() {
        contentView.searchButton.onTap { [unowned self] in
            endEditing()
            getSong()
        }
        
        contentView.tapCopyButtonAction = { [unowned self] in
            presenter?.pasteTextFromBuffer()
        }
    }
}

// MARK: - Private Methods

private extension SearchView {
    func getSong() {
        guard let songUrlString = contentView.linkTextField.text, songUrlString != "" else {
            return
        }
        
        presenter?.getSong(urlString: songUrlString)
    }
}

// MARK: - UITextFieldDelegate

extension SearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        getSong()
        
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

// MARK: - SearchViewProtocol

extension SearchView: SearchViewProtocol {
    func setLink(_ linkString: String) {
        contentView.setLinkText(linkString)
        contentView.enableSearchButton(true)
        
        getSong()
    }
    
    func setLinkTitle(_ title: String) {
        contentView.setCopyButtonTitle(title)
    }
    
    func cleaningLinkTextField() {
        contentView.linkTextField.text = nil
    }
    
    func hideSetLink(_ hidden: Bool) {
        contentView.linkTextField.inputAccessoryView?.isHidden = hidden
    }
    
    func setOffsetLinkTextField(_ keyboardFrame: CGRect) {
        let button = contentView.searchButton
        let buttonHeight = button.frame.origin.y + button.frame.height
        
        guard buttonHeight > keyboardFrame.origin.y else {
            return
        }
        
        let buttonY = keyboardFrame.origin.y - button.frame.height - 16.0
        contentView.setSearchButton(y: buttonY)
    }
    
    func resetPositionLinkTextField() {
        contentView.resetSearchButtonPosition()
    }
    
    func showLoading() {
        contentView.set(loadingAnimationState: .start)
    }
    
    func hideLoading(completion: (() -> Void)? = nil) {
        contentView.set(
            loadingAnimationState: .end,
            completion: completion
        )
    }
    
    func resetLinkTextFieldBorderColor(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.contentView.linkTextField.borderColor = .appGray
            }
        } else {
            contentView.linkTextField.borderColor = .appGray
        }
    }
    
    func endEditing() {
        contentView.endEditing(true)
    }
}
