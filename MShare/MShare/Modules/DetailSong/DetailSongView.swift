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
    
    func setupContent(with state: DetailSongState)
}

final class DetailSongView: ViewController<DetailSongContentView> {
    
    var presenter: DetailSongPresenterProtocol?
    
    var viewController: UIViewController {
        return self
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

}

// MARK: - Setup

private extension DetailSongView {
    
    func setupViews() {
        contentView.horizontalActionMenuView.delegare = self
    }
    
}

// MARK: - DetailSongViewProtocol

extension DetailSongView: DetailSongViewProtocol {
    
    func setupContent(with state: DetailSongState) {
        contentView.set(state: state)
    }
    
}

// MARK: - HorizontalActionMenuDelegate

extension DetailSongView: HorizontalActionMenuDelegate {
    
    func didTapActionItem(_ action: HorizontalMenuAction) {
        print("[dev] tapped on: \(action.title)")
    }
    
}
