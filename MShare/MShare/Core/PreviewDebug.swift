//
//  PreviewDebug.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 13.10.2023.
//

import SwiftUI

struct PreviewUIKitTViewController<T: UIViewController>: UIViewControllerRepresentable {
    let viewController: T
    
    init(_ builder: @escaping (() -> T)) {
        viewController = builder()
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

struct PreviewUIKitView<T: UIView>: UIViewRepresentable {
    let view: T
    
    init(_ builder: @escaping (() -> T)) {
        self.view = builder()
    }
    
    func makeUIView(context: Context) -> some UIView {
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
