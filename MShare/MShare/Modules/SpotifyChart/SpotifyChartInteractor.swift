//
//  SpotifyChartInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import Foundation

protocol SpotifyChartInteractorIntputProtocol {
    var presenter: SpotifyChartInteractorOutputProtocol? { get set }
}

protocol SpotifyChartInteractorOutputProtocol: AnyObject {
    
}

final class SpotifyChartInteractor {
    weak var presenter: SpotifyChartInteractorOutputProtocol?
}

// MARK: - SpotifyChartInteractorInputProtocol

extension SpotifyChartInteractor: SpotifyChartInteractorIntputProtocol {
    
}
