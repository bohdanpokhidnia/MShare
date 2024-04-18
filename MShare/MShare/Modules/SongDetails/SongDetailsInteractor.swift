//
//  SongDetailsInteractor.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 06.08.2022.
//

import UIKit
import Photos

protocol SongDetailsInteractorInputProtocol {
    var presenter: DetailSongInteractorOutputProtocol? { get set }
    
    func requestMedia()
    func requestShareMedia(for destinationService: String)
    func copyImageToBuffer(_ image: UIImage?)
    func saveToDatabase()
    func hasMediaInDatabase()
    func requestAccessToGallery(_ image: UIImage)
}

protocol DetailSongInteractorOutputProtocol: BaseInteractorOutputProtocol {
    func didLoadDetailMedia(_ detailMedia: SongDetailsEntity)
    func didLoadShareMedia(_ shareMedia: ShareMediaResponse)
    func didCatchError(_ error: NetworkError)
    func hasMediaInDatabase(_ isSaved: Bool)
    func didRequestedAccessToGallery(_ image: UIImage)
    func didSaveToDatabase()
    func didDeleteFromDatabase()
}

final class SongDetailsInteractor: BaseInteractor {
    weak var presenter: DetailSongInteractorOutputProtocol?
    
    // MARK: - Initializers
    
    init(
        presenter: DetailSongInteractorOutputProtocol?,
        databaseManager: DatabaseManagerProtocol,
        apiClient: ApiClient,
        factory: FactoryProtocol,
        mediaResponse: MediaResponse,
        cover: UIImage
    ) {
        self.presenter = presenter
        self.databaseManager = databaseManager
        self.apiClient = apiClient
        self.factory = factory
        self.mediaResponse = mediaResponse
        self.cover = cover
        
        super.init(basePresenter: presenter)
    }
    
    // MARK: - Private
    
    private let apiClient: ApiClient
    private let databaseManager: DatabaseManagerProtocol
    private let factory: FactoryProtocol
    private let mediaResponse: MediaResponse
    private let cover: UIImage
}

// MARK: - SongDetailsInteractorInputProtocol

extension SongDetailsInteractor: SongDetailsInteractorInputProtocol {
    func requestMedia() {
        guard let entity = factory.mapDetailEntity(from: mediaResponse, withImage: cover) else {
            return
        }

        presenter?.didLoadDetailMedia(entity)
    }
    
    func requestShareMedia(for destinationService: String) {
        switch mediaResponse.mediaType {
        case .song:
            guard let song = mediaResponse.song else {
                return
            }
            let shareMediaEndpoint = GetShareMedia(
                originService: song.serviceType,
                sourceId: song.songSourceId,
                destinationService: destinationService
            )
            
            Task { @MainActor in
                do {
                    let shareMedia = try await apiClient.request(endpoint: shareMediaEndpoint, response: ShareMediaResponse.self)
                    presenter?.didLoadShareMedia(shareMedia)
                } catch let networkError as NetworkError {
                    presenter?.didCatchError(networkError)
                } catch {
                    presenter?.handleNetworkError(error: NetworkError.message("Not found song for \(destinationService)"))
                }
            }
        case .album:
            break
        }
    }
    
    func copyImageToBuffer(_ image: UIImage?) {
        UIPasteboard.general.image = image
    }
    
    func saveToDatabase() {
        guard let coverData = cover.pngData() else {
            dprint("error get png data from cover", logType: .error)
            return
        }
        
        let mediaModel = MediaModel(mediaResponse: mediaResponse, coverData: coverData)
        
        if let savedMediaModel = databaseManager.getObject(MediaModel.self, forPrimaryKey: mediaModel.sourceId) {
            databaseManager.delete(savedMediaModel) { [weak presenter] (error) in
                guard error == nil else {
                    dprint(error!.localizedDescription)
                    return
                }
                
                presenter?.didDeleteFromDatabase()
            }
        } else {
            databaseManager.save(mediaModel) { [weak presenter] (error) in
                guard error == nil else {
                    dprint(error!.localizedDescription, logType: .error)
                    return
                }
                
                presenter?.didSaveToDatabase()
            }
        }
    }
    
    func hasMediaInDatabase() {
        var mediaModel: MediaModel?
        
        switch mediaResponse.mediaType {
        case .song:
            guard let song = mediaResponse.song else { return }
            mediaModel = databaseManager.getObject(MediaModel.self, forPrimaryKey: song.songSourceId)
            
        case .album:
            guard let album = mediaResponse.album else { return }
            mediaModel = databaseManager.getObject(MediaModel.self, forPrimaryKey: album.albumSourceId)
        }
        
        let isSaved = mediaModel != nil
        presenter?.hasMediaInDatabase(isSaved)
    }
    
    func requestAccessToGallery(_ image: UIImage) {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            dprint("available access to save in library")
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status {
                case .authorized:
                    dprint("access to save in library")
                    
                default:
                    dprint("status requested to gallery", status, logType: .error)
                }
            }
            
        default:
            dprint("we need say user open settings", status, logType: .warning)
        }
        
        presenter?.didRequestedAccessToGallery(image)
    }
}
