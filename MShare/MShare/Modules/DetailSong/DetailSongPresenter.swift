//
//  DetailSongPresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import UIKit

protocol DetailSongPresenterProtocol: AnyObject {
    var view: DetailSongViewProtocol? { get set }
    var interactor: DetailSongInteractorIntputProtocol? { get set }
    var router: DetailSongRouterProtocol? { get set }
    
    func viewDidLoad()
    func dismissAction()
    func copyCoverToBuffer(fromView view: View)
    func shareCover(cover: UIImage, completion: (() -> Void)?)
}

final class DetailSongPresenter {
    var view: DetailSongViewProtocol?
    var interactor: DetailSongInteractorIntputProtocol?
    var router: DetailSongRouterProtocol?
}

// MARK: - DetailSongPresenterProtocol

extension DetailSongPresenter: DetailSongPresenterProtocol {
    
    func viewDidLoad() {
        interactor?.requestSong()
    }
    
    func dismissAction() {
        router?.dismissModule(view: view)
    }
    
    func copyCoverToBuffer(fromView: View) {
        let image = fromView.makeSnapShotImage(withBackground: false)
        interactor?.copyImageToBuffer(image)
        
        view?.showCopiedToast()
        
        view?.setCoverAnimation(animationState: .pressed) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.view?.setCoverAnimation(animationState: .unpressed, completion: nil)
            }
        }
    }
    
    func shareCover(cover: UIImage, completion: (() -> Void)?) {
        router?.shareImage(view: view, image: cover, completion: completion)
    }
    
}

// MARK: - DetailSongInteractorOutputProtocol

extension DetailSongPresenter: DetailSongInteractorOutputProtocol {
    
    func didLoadSong(_ song: DetailSongEntity) {
        var menuItems = [HorizontalActionMenuItem]()
        
        song.services.forEach {
            guard let action = HorizontalMenuAction(rawValue: $0.type) else { return }
            menuItems.append(.init(horizontalMenuAction: action, available: $0.isAvailable))
        }
        menuItems.append(.init(horizontalMenuAction: .shareCover, available: true))
        
        view?.setupContent(withState: song, withHorizontalActionMenuItem: menuItems)
    }
    
}
