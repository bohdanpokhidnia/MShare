//
//  DetailSongView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import UIKit

protocol DetailSongViewProtocol: AnyObject {
    var presenter: DetailSongPresenterProtocol? { get set }
    var viewController: UIViewController { get }
}

class DetailSongView: ViewController<DetailSongContentView> {
    
    var presenter: DetailSongPresenterProtocol?
    var viewController: UIViewController {
        return self
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

// MARK: - DetailSongViewProtocol

extension DetailSongView: DetailSongViewProtocol {
    
}
