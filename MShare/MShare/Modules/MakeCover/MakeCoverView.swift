//
//  MakeCoverView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 02.04.2023.
//

import UIKit

protocol MakeCoverViewProtocol: AnyObject {
    var presenter: MakeCoverPresenterProtocol? { get set }
    var viewController: UIViewController { get }
    
    func setupContent(from enitiy: DetailSongEntity)
}

final class MakeCoverView: ViewController<MakeCoverContentView> {
    
    var presenter: MakeCoverPresenterProtocol?
    
    var viewController: UIViewController {
        return self
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter?.viewDidLoad()
    }

}

// MARK: - MakeCoverViewProtocol

extension MakeCoverView: MakeCoverViewProtocol {
    
    func setupContent(from enitiy: DetailSongEntity) {
        contentView.set(state: enitiy)
    }
    
}
