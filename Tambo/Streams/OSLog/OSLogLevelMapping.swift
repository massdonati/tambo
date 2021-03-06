//
//  SLOSLogLevelMapping.swift
//  Tambo
//
//  Created by Massimo Donati on 7/23/18.
//

import Foundation
import os

/**
 Specifies the manner in which an `OSLogType` is selected to represent a
 given `LogEntry`.

 When a log entry is being recorded by an `OSLogRecorder`, an `OSLogType`
 value is used to specify the importance of the message; it is similar in
 concept to the `LogSeverity`.

 Because there is not an exact one-to-one mapping between `OSLogType` and
 `LogSeverity` values, `OSLogTypeTranslation` provides a mechanism for
 deriving the appropriate `OSLogType` for a given `LogEntry`.
 */
@available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *)
public enum OSLogTypeMapper {
    /**
     A strict translation from a `LogEntry`'s `severity` to an
     `OSLogType` value. Warnings are treated as errors; errors are
     treated as faults.

     This will result in additional logging overhead being recorded by OSLog,
     and is not recommended unless you have a specific need for this.
     LogSeverity|OSLogType
     -----------|---------
     `.trace` | `.debug`
     `.debug`   | `.debug`
     `.info`    | `.info`
     `.warning` | `.info`
     `.error`   | `.error`
     `.critical`   | `.fault`
     */
    case `default`

    /** Uses a custom function to determine the `OSLogType` to use for each
     `LogEntry`. */
    case function((LogLevel) -> OSLogType)

    /**
     Maps Tambo `TLog`s levels into `OSLogType`s.
     - parameter level: The LogLevel to be mapped.
     - returns: The corresponding OSLogType.
     */
    internal func osLogType(for level: LogLevel) -> OSLogType {
        switch self {
        case .default:
            switch level {
            case .trace: return .debug
            case .debug: return .debug
            case .info: return .info
            case .warning: return .info
            case .error: return .error
            case .critical: return .fault
            }

        case .function(let mapperFunc):
            return mapperFunc(level)
        }
    }
}
