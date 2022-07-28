//
//  SearchView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit

protocol SearchViewProtocol: AnyObject {
    var presenter: SearchPresenterProtocol? { get set }
    var viewController: UIViewController { get }
}

class SearchView: ViewController<SearchContentView> {
    
    var presenter: SearchPresenterProtocol?
    var viewController: UIViewController {
        return self
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

// MARK: - SearchViewProtocol

extension SearchView: SearchViewProtocol {
    
}
