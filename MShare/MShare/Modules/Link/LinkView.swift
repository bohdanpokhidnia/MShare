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
        
    }

}

// MARK: - LinkViewProtocol

extension LinkView: LinkViewProtocol {
    
}
