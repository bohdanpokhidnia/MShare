//
//  AppleMusicChartInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import Foundation

protocol AppleMusicChartInteractorIntputProtocol {
    var presenter: AppleMusicChartInteractorOutputProtocol? { get set }
}

protocol AppleMusicChartInteractorOutputProtocol: AnyObject {
    
}

final class AppleMusicChartInteractor {
    weak var presenter: AppleMusicChartInteractorOutputProtocol?
}

// MARK: - AppleMusicChartInteractorInputProtocol

extension AppleMusicChartInteractor: AppleMusicChartInteractorIntputProtocol {
    
}
