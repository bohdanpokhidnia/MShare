//
//  OnboardingView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 20.01.2023.
//

import UIKit

protocol OnboardingViewProtocol: AnyObject {
    var presenter: OnboardingPresenterProtocol? { get set }
    var viewController: UIViewController { get }
}

final class OnboardingView: ViewController<OnboardingContentView> {
    
    var presenter: OnboardingPresenterProtocol?
    
    var viewController: UIViewController {
        return self
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        add(child: contentView.pageController, to: contentView.containerPageController)
        
        setupActionHandlers()
    }
    
}

// MARK: - Setup

private extension OnboardingView {
    
    func setupActionHandlers() {
        contentView.letsGoButton.whenTap { [weak self] in
            self?.presenter?.didTapLetsGo()
        }
    }
    
}

// MARK: - OnboardingViewProtocol

extension OnboardingView: OnboardingViewProtocol {
    
}
