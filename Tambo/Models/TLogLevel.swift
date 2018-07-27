//
//  TLogLevel.swift
//  Tambo
//
//  Created by Massimo Donati on 7/23/18.
//

import Foundation

public enum TLogLevel: Int {
    case error = 0, warning = 1, info = 2, debug = 3, verbose = 4

    var name: String {
        switch self {
        case .error: return "error"
        case .warning: return "warning"
        case .info: return "info"
        case .debug: return "debug"
        case .verbose: return "verbose"
        }
    }

    var symbol: String {
        switch self {
        case .error: return "❌"
        case .warning: return "⚠️"
        case .info: return "ℹ️"
        case .debug: return "🐞"
        case .verbose: return "⚪️"
        }
    }
}

extension TLogLevel: Comparable, Equatable {
    public static func < (lhs: TLogLevel, rhs: TLogLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
