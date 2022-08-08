//
//  ChartInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 08.08.2022.
//

import Foundation

protocol ChartInteractorIntputProtocol {
    var presenter: ChartInteractorOutputProtocol? { get set }
}

protocol ChartInteractorOutputProtocol: AnyObject {
    
}

final class ChartInteractor {
    weak var presenter: ChartInteractorOutputProtocol?
}

// MARK: - ChartInteractorInputProtocol

extension ChartInteractor: ChartInteractorIntputProtocol {
    
}
