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
    func cleaningLinkTextField()
    func hideSetLink(_ hidden: Bool)
    func showError(title: String?, message: String, action: (() -> Void)?)
    func setOffsetLinkTextField(_ keyboardFrame: CGRect)
    func resetPositionLinkTextField()
    func showLoading()
    func hideLoading(completion: (() -> Void)?)
    func resetLinkTextFieldBorderColor(animated: Bool)
}

extension LinkViewProtocol {
    
    func showError(title: String?, message: String, action: (() -> Void)? = nil) {
        showError(title: title, message: message, action: action)
    }
    
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
        setupActionsHandlers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.viewWillDisappear()
    }

}

// MARK: - Setup

private extension LinkView {
    
    func setupViews() {
        contentView.linkTextField.make {
            $0.delegate = self
            $0.addTarget(self, action: #selector(UIResponder.becomeFirstResponder), for: .editingDidEndOnExit)
        }
    }
    
    func setupNavigationBar() {
        title = "Link"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setupActionsHandlers() {
        contentView.searchButton.whenTap { [unowned self] in
            contentView.endEditing(true)
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
    
    func showError(title: String?, message: String, action: (() -> Void)? = nil) {
        showAlert(title: title, message: message, alertAction: action)
    }
    
    func setOffsetLinkTextField(_ keyboardFrame: CGRect) {
//        let viewFrame = contentView.controlsStackView.frame
//        
//        if viewFrame.origin.y + viewFrame.height > keyboardFrame.origin.y {
//            let viewHeight = viewFrame.origin.y + viewFrame.height
//            let offSet = viewHeight - keyboardFrame.origin.y
//            
//            UIView.animate(withDuration: 0.3) {
//                self.contentView.frame.origin.y -= offSet + self.contentView.controlsStackView.spacing
//            }
//        }
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
        
        var startFrame = contentView.searchButton.frame
        startFrame.size.width = startFrame.height
        startFrame.origin = .init(x: contentView.center.x - startFrame.width / 2, y: contentView.center.y - startFrame.height / 2)
        let cornerRadius = (startFrame.width + startFrame.height) / 4
        
        contentView.searchButton.make {
            $0.set(animationState: animationState, finalFrame: startFrame, cornerRadius: cornerRadius)
        }
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
                var endFrame = self.contentView.searchButton.frame
                endFrame.size = .init(width: UIScreen.main.bounds.width - self.contentView.controlsPadding * 2, height: self.contentView.controlsHeight)
                endFrame.origin = .init(x: self.contentView.center.x - endFrame.width / 2, y: self.contentView.center.y - endFrame.height / 2)
                
                self.contentView.searchButton.set(animationState: animationState,
                                             finalFrame: endFrame,
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
