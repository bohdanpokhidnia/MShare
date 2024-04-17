//
//  HorizontalActionMenuDelegate.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 17.04.2024.
//

import Foundation

protocol HorizontalActionMenuDelegate: AnyObject {
    func didTapActionItem(
        _ horizontalActionMenuView: HorizontalActionMenuView,
        action: HorizontalMenuAction,
        available: Bool,
        didSelectItemAt indexPath: IndexPath
    )
}
