//
//  Label.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 15.09.2022.
//

import UIKit

class Label: UILabel {
    // MARK: - Override property
    
    override var text: String? {
        didSet {
            setCharacterSpacing()
        }
    }
    
    // MARK: - Private
    
    private var kernValue: Double = 0
}

// MARK: - Private Methods

private extension Label {
    func setCharacterSpacing() {
        guard let text, !text.isEmpty else { return }
        
        let string = NSMutableAttributedString(string: text)
        let range = NSRange(location: 0, length: string.length)
        string.addAttribute(.kern, value: kernValue, range: range)
        attributedText = string
    }
}

// MARK: - Set

extension Label {
    @discardableResult
    func set(characterSpacing kernValue: Double) -> Self {
        self.kernValue = kernValue
        return self
    }
}
