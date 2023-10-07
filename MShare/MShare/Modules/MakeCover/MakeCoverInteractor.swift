//
//  MakeCoverInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 02.04.2023.
//

import UIKit

protocol MakeCoverInteractorIntputProtocol {
    var presenter: MakeCoverInteractorOutputProtocol? { get set }
    
    func requestData()
}

protocol MakeCoverInteractorOutputProtocol: AnyObject {
    func didLoadData(entity: DetailSongEntity)
}

final class MakeCoverInteractor {
    
    weak var presenter: MakeCoverInteractorOutputProtocol?
    
    // MARK: - Initializers
    
    init(
        presenter: MakeCoverInteractorOutputProtocol?,
        factory: FactoryProtocol,
        mediaResponse: MediaResponse,
        cover: UIImage?
    ) {
        self.presenter = presenter
        self.factory = factory
        self.mediaResponse = mediaResponse
        self.cover = cover
    }
    
    // MARK: - Private
    
    private let factory: FactoryProtocol
    private let mediaResponse: MediaResponse
    private let cover: UIImage?
    
}

// MARK: - MakeCoverInteractorInputProtocol

extension MakeCoverInteractor: MakeCoverInteractorIntputProtocol {
    
    func requestData() {
        guard let entity = factory.mapDetailEntity(from: mediaResponse, withImage: cover) else { return }
        
        presenter?.didLoadData(entity: entity)
    }
    
}
