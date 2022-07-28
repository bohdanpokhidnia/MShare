//
//  AppleMusicChartView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import UIKit

protocol AppleMusicChartViewProtocol: AnyObject {
    var presenter: AppleMusicChartPresenterProtocol? { get set }
    var viewController: UIViewController { get }
}

class AppleMusicChartView: ViewController<AppleMusicChartContentView> {
    
    var presenter: AppleMusicChartPresenterProtocol?
    var viewController: UIViewController {
        return self
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Apple Music"
        contentView.backgroundColor = .red
    }

}

// MARK: - AppleMusicChartViewProtocol

extension AppleMusicChartView: AppleMusicChartViewProtocol {
    
}

