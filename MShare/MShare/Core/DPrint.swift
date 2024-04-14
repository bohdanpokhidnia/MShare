//
//  DPrint.swift
//  MShare
//
//  Created by Bohdan Pokhidnia on 07.10.2023.
//

import Foundation

enum LogType {
    case info
    case success
    case warning
    case error
    case custom(customValue: String)
    
    var value: String {
        switch self {
        case .info: "ℹ️"
        case .success: "✅"
        case .warning: "⚠️"
        case .error: "❌"
        case .custom(let customValue): customValue
        }
    }
}

func dprint(_ items: Any..., logType: LogType = .info, filename: String = #file, line: Int = #line, funcName: String = #function, separator: String = " ", terminator: String = "\n") {
    let queue = Thread.isMainThread ? "UI" : "BG"
    
    #if DEBUG
    print("\n\(queue): \(logType.value) [\(sourceFileName(filePath: filename))]:\(line) \(shortFuncName(funcName: funcName)) ->")
    
    for (index, item) in items.enumerated() {
        let separator = index != 0 ? separator : ""
        print("\(separator)\(item)", terminator: "")
    }
    
    print(terminator)
    #endif
}

func minDprint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    print(items, separator: separator, terminator: terminator)
    #endif
}

fileprivate func sourceFileName(filePath: String) -> String {
    let components = filePath.components(separatedBy: "/")
    return components.isEmpty ? "" : components.last!
}

fileprivate func shortFuncName(funcName: String) -> String {
    let components = funcName.components(separatedBy: ":")
    return components.count > 1 ? "\(components.first!):...)" : funcName
}
