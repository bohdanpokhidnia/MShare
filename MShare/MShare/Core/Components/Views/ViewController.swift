//
//  ViewController.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 27.07.2022.
//

import UIKit

class ViewController<ContentView: View>: UIViewController {
    
    var contentView: ContentView! {
        return view as? ContentView
    }
    
    // MARK: - Lifecycle
    
    required init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override methods
    
    override func loadView() {
        view = ContentView()
    }
    
}

// MARK: - Alerts

extension ViewController {
    
    func showAlert(title: String? = nil, message: String, alertAction: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert).make {
            $0.addAction(.init(title: "OK", style: .default, handler: { _ in
                alertAction?()
            }))
        }
        
        present(alertController, animated: true)
    }
    
}
