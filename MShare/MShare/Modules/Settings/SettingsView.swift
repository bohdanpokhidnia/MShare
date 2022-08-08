//
//  SettingsView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol SettingsViewProtocol: AnyObject {
    var presenter: SettingsPresenterProtocol? { get set }
    var viewController: UIViewController { get }
}

final class SettingsView: ViewController<SettingsContentView> {
    
    var presenter: SettingsPresenterProtocol?
    var viewController: UIViewController {
        return self
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        contentView.backgroundColor = .systemGray
    }

}

// MARK: - SettingsViewProtocol

extension SettingsView: SettingsViewProtocol {
    
}
