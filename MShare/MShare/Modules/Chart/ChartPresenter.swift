//
//  ChartPresenter.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 08.08.2022.
//

import Foundation

protocol ChartPresenterProtocol: AnyObject {
    var view: ChartViewProtocol? { get set }
    var interactor: ChartInteractorIntputProtocol? { get set }
    var router: ChartRouterProtocol? { get set }
}

final class ChartPresenter {
    weak var view: ChartViewProtocol?
    var interactor: ChartInteractorIntputProtocol?
    var router: ChartRouterProtocol?
}

// MARK: - ChartPresenterProtocol

extension ChartPresenter: ChartPresenterProtocol {
    
}

// MARK: - ChartInteractorOutputProtocol

extension ChartPresenter: ChartInteractorOutputProtocol {
    
}
