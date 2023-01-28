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
    
    // MARK: - UI
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        add(child: contentView.pageController, to: contentView.containerPageController)
    }
    
}

// MARK: - OnboardingViewProtocol

extension OnboardingView: OnboardingViewProtocol {
    
}
