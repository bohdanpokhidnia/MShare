//
//  ChartView.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 08.08.2022.
//

import UIKit

protocol ChartViewProtocol: AnyObject {
    var presenter: ChartPresenterProtocol? { get set }
    var viewController: UIViewController { get }
}

final class ChartView: ViewController<ChartContentView> {
    
    var presenter: ChartPresenterProtocol?
    
    var viewController: UIViewController {
        return self
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }

}

// MARK: - Setup

private extension ChartView {
    
    func setupNavigationBar() {
        title = "Chart"
    }
    
}

// MARK: - ChartViewProtocol

extension ChartView: ChartViewProtocol {
    
}
