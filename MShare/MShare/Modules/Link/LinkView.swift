//
//  LinkView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit
import SnapKit

protocol LinkViewProtocol: BaseView {
    var presenter: LinkPresenterProtocol? { get set }
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

final class LinkView: ViewController<LinkContentView> {
    var presenter: LinkPresenterProtocol?
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
        
        presenter?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter?.viewWillDisappear()
    }
    
    // MARK: - Override methods
    
    override func handleNetworkError(error: BaseError) {
        let tabBarController = parent?.parent as? UITabBarController
        let tabBarHeight: CGFloat = tabBarController?.tabBar.frame.height ?? .zero
        
        hideLoading() {
            AlertKit.toast(
                title: error.localizedDescription,
                position: .bottom(inset: tabBarHeight),
                haptic: .error
            )
        }
    }
}

// MARK: - Setup

private extension LinkView {
    func setupNavigationBar() {
        title = "Link"
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

private extension LinkView {
    func getSong() {
        guard let songUrlString = contentView.linkTextField.text, songUrlString != "" else {
            return
        }
        
        presenter?.getSong(urlString: songUrlString)
    }
}

// MARK: - UITextFieldDelegate

extension LinkView: UITextFieldDelegate {
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
        contentView.set(loadingAnimationState: .end)
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
