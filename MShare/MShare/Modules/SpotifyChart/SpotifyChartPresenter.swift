//
//  SpotifyChartPresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import Foundation

protocol SpotifyChartPresenterProtocol: AnyObject {
    var view: SpotifyChartViewProtocol? { get set }
    var interactor: SpotifyChartInteractorIntputProtocol? { get set }
    var router: SpotifyChartRouterProtocol? { get set }
}

final class SpotifyChartPresenter {
    var view: SpotifyChartViewProtocol?
    var interactor: SpotifyChartInteractorIntputProtocol?
    var router: SpotifyChartRouterProtocol?
}

// MARK: - SpotifyChartPresenterProtocol

extension SpotifyChartPresenter: SpotifyChartPresenterProtocol {
    
}

// MARK: - SpotifyChartInteractorOutputProtocol

extension SpotifyChartPresenter: SpotifyChartInteractorOutputProtocol {
    
}
