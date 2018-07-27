//
//  TStreamProtocol.swift
//  Tambo
//
//  Created by Massimo Donati on 7/23/18.
//

import Foundation

/// Protocol for stream classes to conform to
public protocol TStreamProtocol: CustomDebugStringConvertible {
    /// Identifier for the stream (should be unique)
    var identifier: String {get set}

    /// Log level for this stream
    var outputLevel: TLogLevel {get set}

    /// Flag whether or not we've logged the app details to this stream
    var haveLoggedAppDetails: Bool { get set }

    var logFormatter: TLogFormatterProtocol {get set}

    /// Array of log filters to apply to messages before they're output
//    var filters: [FilterProtocol]? { get set }

    // MARK: - Methods
    /**
     Process the log details.
     - parameter logDetails: Structure with all of the details for the log to
        process.
     - note: this is called by the logger whenever it receive a log from the
        client.
    */
    func process(log: TLog)

    /**
     Check if the stream's log level is equal to or lower than the
     specified level.
     - parameter level: The log level to check.
     - returns: true if the stream is at the log level specified or lower.
        false otherwise.
     */
    func isEnabled(for level: TLogLevel) -> Bool

    /**
     Apply filters to determine if the log message should be logged.
     - parameter logDetails: The log details.
     - returns: true if the log object can be discarded
     */
    func should(filter log: TLog) -> Bool
}

extension TStreamProtocol {

    /// Iterate over all of the log filters in this stream, or the logger if none set for the stream.
    ///
    /// - Parameters:
    ///     - logDetails: The log details.
    ///     - message: Formatted/processed message ready for output.
    ///
    /// - Returns:
    ///     - true:     Drop this log message.
    ///     - false:    Keep this log message and continue processing.
    ///
    public func should(filter log: TLog) -> Bool {
        return false

        //        guard let filters = self.filters ?? self.owner?.filters, filters.count > 0 else { return false }
//
//        for filter in filters {
//            if filter.shouldExclude(logDetails: &logDetails, message: &message) {
//                return true
//            }
//        }
//
//        return false
    }

    public func isEnabled(for level: TLogLevel) -> Bool {
        return level <= outputLevel
    }

    public var debugDescription: String {
        get {
            return ""
        }
    }
}
