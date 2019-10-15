//
//  TLogLevel.swift
//  Tambo
//
//  Created by Massimo Donati on 7/23/18.
//

import Foundation

/**
 Defines the available levels of severity a log carries the informations of.
 The use of these levels are deffered to the user of this framework.
 */
public enum TLogLevel: Int {
    case error = 0
    case warning = 1
    case info = 2
    case debug = 3
    case verbose = 4

    /// The string name associated to each level.
    var name: String {
        switch self {
        case .error: return "error"
        case .warning: return "warning"
        case .info: return "info"
        case .debug: return "debug"
        case .verbose: return "verbose"
        }
    }

    /// The symble associated to each level.
    var symbol: String {
        switch self {
        case .error: return "♦️"
        case .warning: return "🔶"
        case .info: return "🔷"
        case .debug: return "🐞"
        case .verbose: return "🔊"
        }
    }
}

extension TLogLevel: Comparable, Equatable {
    /// two levels are `the same` if their raw value is the same.
    public static func < (lhs: TLogLevel, rhs: TLogLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
