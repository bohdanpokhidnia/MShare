//
//  LinkView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol LinkViewProtocol: BaseModuleView {
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
}

final class LinkView: ViewController<LinkContentView> {
    
    var presenter: LinkPresenterProtocol?
    var viewController: UIViewController { self }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupViews()
        setupActionsHandlers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter?.viewWillDisappear()
    }
    
    // MARK: - Private
    
    private var baseButtonRect: CGRect = .zero

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
    
    func setupActionsHandlers() {
        contentView.searchButton.whenTap { [unowned self] in
            contentView.endEditing(true)
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
        guard let songUrlString = contentView.linkTextField.text, songUrlString != "" else { return }
        
        presenter?.getSong(urlString: songUrlString)
    }
    
}


// MARK: - UITextFieldDelegate

extension LinkView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contentView.endEditing(true)
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
        let buttonFrame = contentView.searchButton.frame
        let buttonHeight = buttonFrame.origin.y + buttonFrame.height
        let isOverKeyboard = keyboardFrame.origin.y < buttonHeight
        
        guard isOverKeyboard else { return }
        let offset = (buttonHeight - keyboardFrame.origin.y) + 16
        let newOffset = self.contentView.frame.offsetBy(dx: 0, dy: -offset)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut) {
            self.contentView.frame = newOffset
        }
    }
    
    func resetPositionLinkTextField() {
        UIView.animate(withDuration: 0.1) {
            self.contentView.frame.origin.y = 0
        }
    }
    
    func showLoading() {
        let animationState: LoadingButton.AnimationState = .start
        
        switch animationState {
        case .start:
            UIView.animate(withDuration: animationState.duration) {
                self.contentView.linkTextField.alpha = 0
            }
            
        case .end:
            break
        }
        
        contentView.linkTextField.alpha = 0
        
        baseButtonRect = contentView.searchButton.frame
        var startFrame = baseButtonRect
        startFrame.size.width = startFrame.height
        startFrame.origin = .init(x: contentView.center.x - startFrame.width / 2, y: contentView.center.y - startFrame.height / 2)
        let cornerRadius = (startFrame.width + startFrame.height) / 4
        
        contentView.searchButton.set(animationState: animationState, finalFrame: startFrame, cornerRadius: cornerRadius)
    }
    
    func hideLoading(completion: (() -> Void)? = nil) {
        let animationState: LoadingButton.AnimationState = .end
        
        switch animationState {
        case .start:
            break
            
        case .end:
            UIView.animate(withDuration: animationState.duration) {
                self.contentView.linkTextField.alpha = 1
            } completion: { _ in
                self.contentView.searchButton.set(animationState: animationState,
                                                  finalFrame: self.baseButtonRect,
                                                  cornerRadius: 12,
                                                  completion: completion)
            }

        }
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
    
}
