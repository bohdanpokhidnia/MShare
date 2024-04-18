//
//  SearchPresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 28.07.2022.
//

import UIKit
import TipKit

protocol SearchPresenterProtocol: AnyObject {
    var view: SearchViewProtocol? { get set }
    var interactor: SearchInteractorIntputProtocol? { get set }
    var router: SearchRouterProtocol? { get set }
    
    func viewWillAppear()
    func viewWillDisappear()
    func pasteTextFromBuffer()
    func getSong(urlString: String)
}

final class SearchPresenter: BasePresenter {
    weak var view: SearchViewProtocol?
    var interactor: SearchInteractorIntputProtocol?
    var router: SearchRouterProtocol?
    
    // MARK: - Initializers
    
    init(
        view: SearchViewProtocol?,
        router: SearchRouterProtocol?
    ) {
        self.view = view
        self.router = router
        
        super.init(baseView: view)
    }
    
    // MARK: - Override methods
    
    override func handleNetworkError(error: BaseError) {
        if let networkError = error as? NetworkError {
            let title = switch networkError {
            case .networkError(let networkErrorResponse):
                networkErrorResponse.errors.contains(where: { $0.key == "url" }) ? "Failed url on song or album" : networkErrorResponse.title
                
            default:
                networkError.localizedDescription
            }
            
            view?.hideLoading(completion: {
                DispatchQueue.main.async {
                    AlertKit.shortToast(
                        title: title,
                        icon: .error,
                        position: .top,
                        haptic: .error,
                        inset: 16.0
                    )
                }
            })
        } else {
            view?.handleNetworkError(error: error)
        }
    }
    
    // MARK: - Private
    
    private var stringFromBuffer: String?
}

// MARK: - SearchPresenterProtocol

extension SearchPresenter: SearchPresenterProtocol {
    func viewWillAppear() {
        interactor?.setupNotifications()
        
        if #available(iOS 17.0, *) {
            guard let interactor else {
                return
            }
            let isViewedTip = !interactor.isDisplaySearchTip
            SearchTip.hasViewedTip = isViewedTip
            presentTip()
        }
    }
    
    func viewWillDisappear() {
        interactor?.removeNotifications()
    }
    
    func pasteTextFromBuffer() {
        guard let stringFromBuffer = stringFromBuffer else {
            return
        }
        
        view?.setLink(stringFromBuffer)
        self.stringFromBuffer = nil
        view?.hideSetLink(true)
    }
    
    func getSong(urlString: String) {
        view?.showLoading()
        
        if #available(iOS 17.0, *) {
            SearchTip.hasViewedTip = false
            interactor?.set(isDisplaySearchTip: true)
        }
        
        interactor?.requestSong(urlString: urlString)
    }
}

// MARK: - LinkInteractorOutputProtocol

extension SearchPresenter: SearchInteractorOutputProtocol {
    func didCatchURL(_ urlString: String) {
        view?.setLink(urlString)
    }
    
    func didCatchFromBuffer(string: String) {
        view?.hideSetLink(!string.isValidURL)
        self.stringFromBuffer = string
        view?.setLinkTitle(string)
    }
    
    func didShowKeyboard(_ keyboardFrame: NSValue) {
        view?.setOffsetLinkTextField(keyboardFrame.cgRectValue)
    }
    
    func didHideKeyboard(_ keyboardFrame: NSValue) {
        view?.resetPositionLinkTextField()
    }
    
    func didFetchMedia(mediaResponse: MediaResponse, cover: UIImage?) {
        guard let cover else {
            return
        }
        
        view?.endEditing()
        
        router?.presentSongDetailsScreen(from: view, mediaResponse: mediaResponse, cover: cover) { [weak view] in
            view?.cleaningLinkTextField()
            view?.hideLoading(completion: nil)
        }
    }
}

@available(iOS 17.0, *)
private extension SearchPresenter {
    struct SearchTip: Tip {
        var title: Text { Text("Search link for song") }
        var message: Text? { Text("Paste a link to a song from Apple Music or Spotify") }
        var image: Image? { Image(systemName: "magnifyingglass") }
        
        @Parameter
        static var hasViewedTip: Bool = false
        
        var rules: [Rule] {
            #Rule(SearchTip.$hasViewedTip) { $0 == true }
        }
        
        var options: [TipOption] {
            [Tip.MaxDisplayCount(1)]
        }
    }
    
    func presentTip() {
        Task { @MainActor in
            for await shouldDisplay in SearchTip().shouldDisplayUpdates {
                guard shouldDisplay else {
                    router?.dismissPresentedPopover(for: view)
                    return
                }
                guard let sourceItem = view?.tipSource else {
                    return
                }
                
                let popoverController = TipUIPopoverViewController(SearchTip(), sourceItem: sourceItem)
                router?.present(from: view, viewController: popoverController)
            }
        }
    }
}
