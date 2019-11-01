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
 - `error`: used when the application really is in trouble. Users are being affected
    without having a way to work around the issue.
 - `warning`: when something bad happened, but the application still has the chance to
    heal itself or the issue can wait a day or two to be fixed.
 - `info`: when something bad happened, but the application still has the chance to
    heal itself or the issue can wait a day or two to be fixed.
 - `debug`: any information that helps us identify what went wrong on DEBUG level.
    - error messages when an incoming HTTP request was malformed, resulting in a 4xx HTTP
        status
    - variable values in business logic.
 - `trace`:
 */
public enum TLogLevel: Int {
    case error = 0
    case warning = 1
    case info = 2
    case debug = 3
    case trace = 4

    /// The string name associated to each level.
    var name: String {
        switch self {
        case .error: return "error"
        case .warning: return "warning"
        case .info: return "info"
        case .debug: return "debug"
        case .trace: return "trace"
        }
    }

    /// The symble associated to each level.
    var symbol: String {
        switch self {
        case .error: return "♦️"
        case .warning: return "🔶"
        case .info: return "🔷"
        case .debug: return "🐞"
        case .trace: return "🔊"
        }
    }
}

extension TLogLevel: Comparable, Equatable {
    /// two levels are `the same` if their raw value is the same.
    public static func < (lhs: TLogLevel, rhs: TLogLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}
