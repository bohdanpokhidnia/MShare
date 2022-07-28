//
//  SpotifyChartView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import UIKit

protocol SpotifyChartViewProtocol: AnyObject {
    var presenter: SpotifyChartPresenterProtocol? { get set }
    var viewController: UIViewController { get }
}

class SpotifyChartView: ViewController<SpotifyChartContentView> {
    
    var presenter: SpotifyChartPresenterProtocol?
    var viewController: UIViewController {
        return self
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Spotify"
        contentView.backgroundColor = .green
    }

}

// MARK: - SpotifyChartViewProtocol

extension SpotifyChartView: SpotifyChartViewProtocol {
    
}
