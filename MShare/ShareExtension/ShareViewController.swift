//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Bohdan Pokhidnia on 29.07.2022.
//

import UIKit
import UniformTypeIdentifiers

class ShareViewController: UIViewController {
    private var appURLString = "ShareExtension://home?url="
    private let typeText = UTType.text
    private let typeURL = UTType.url
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let itemProvider = extensionItem.attachments?.last else {
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            return
        }
        
        //for catch apple music share song from playlist and etc.
        if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
            itemProvider.loadDataRepresentation(forTypeIdentifier: "public.url") { (_, _) in }
        }
        
        if itemProvider.hasItemConformingToTypeIdentifier(typeText.identifier) {
            handleIncomingText(itemProvider: itemProvider)
        } else if itemProvider.hasItemConformingToTypeIdentifier(typeURL.identifier) {
            handleIncomingURL(itemProvider: itemProvider)
        } else {
            dprint("unknown UTType", logType: .error)
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }
    
    private func handleIncomingText(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: typeText.identifier, options: nil) { (item, error) in
            guard error == nil else {
                dprint(error!, logType: .error)
                return
            }
            
            guard let text = item as? String else { return }
            
            self.appURLString += text
            
            self.openMainApp()
        }
    }
    
    private func handleIncomingURL(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: typeURL.identifier, options: nil) { (item, error) in
            guard error == nil else {
                dprint(error!, logType: .error)
                return
            }
            guard let url = item as? NSURL else {
                return
            }
            guard let urlString = url.absoluteURL?.absoluteString else {
                return
            }
            
            self.appURLString += urlString
            self.openMainApp()
        }
    }
    
    private func openMainApp() {
        extensionContext?.completeRequest(returningItems: nil, completionHandler: { [weak self] _ in
            guard let self = self else { return }
            guard let url = URL(string: self.appURLString) else { return }
            
            self.openURL(url)
        })
    }
    
    @objc
    func openURL(_ url: URL) {
        var responder: UIResponder? = self
        
        while responder != nil {
            if let application = responder as? UIApplication {
                application.perform(#selector(openURL(_:)), with: url)
            }
            
            responder = responder?.next
        }
    }
}
