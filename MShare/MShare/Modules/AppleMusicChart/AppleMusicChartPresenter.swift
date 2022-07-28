//
//  AppleMusicChartPresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import Foundation

protocol AppleMusicChartPresenterProtocol: AnyObject {
    var view: AppleMusicChartViewProtocol? { get set }
    var interactor: AppleMusicChartInteractorIntputProtocol? { get set }
    var router: AppleMusicChartRouterProtocol? { get set }
}

final class AppleMusicChartPresenter {
    var view: AppleMusicChartViewProtocol?
    var interactor: AppleMusicChartInteractorIntputProtocol?
    var router: AppleMusicChartRouterProtocol?
}

// MARK: - AppleMusicChartPresenterProtocol

extension AppleMusicChartPresenter: AppleMusicChartPresenterProtocol {
    
}

// MARK: - AppleMusicChartInteractorOutputProtocol

extension AppleMusicChartPresenter: AppleMusicChartInteractorOutputProtocol {
    
}
