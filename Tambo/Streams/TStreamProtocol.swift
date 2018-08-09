//
//  TStreamProtocol.swift
//  Tambo
//
//  Created by Massimo Donati on 7/23/18.
//

import Foundation

/**
 Protocol for stream classes to conform to.
 - Tag: T.TStreamProtocol
 */
public protocol TStreamProtocol: class {

    var isAsync: Bool {get set}

    /// Identifier for the stream (should be unique)
    var identifier: String {get set}

    /// Log level for this stream. All levels > than this one will be ignored.
    var outputLevel: TLogLevel {get set}

    /// The queue the base stream is serially dispatching to.
    var queue: DispatchQueue {get set}

    /// Array of log filters to apply to messages before they're output
//    var filters: [FilterProtocol]? { get set }

    /**
     Process the log details.
     - parameter logDetails: Structure with all of the details for the log to
        process.
     - note: this is called by the logger whenever it receive a log from the
        client.
    */
    func process(_ log: TLog)

    /**
     Check if the stream's log level is equal to or lower than the
     specified level.
     - parameter level: The log level to check.
     - returns: true if the stream is at the log level specified or lower.
        false otherwise.
     */
    func isEnabled(for level: TLogLevel) -> Bool

    /**
     Applies the filters to determine if the log object should be processed.
     - parameter log: The log object the stream should decide if it should be processed or not.
     - returns: false if the log object can be discarded, true if the stream should process and output the log.
     */
    func should(process log: TLog) -> Bool
}

extension TStreamProtocol {

    public func should(process log: TLog) -> Bool {
        return true
    }

    public func streamQueue(with q: DispatchQueue? = nil) -> DispatchQueue {
        return DispatchQueue(
            label: "com.tambo.stream.\(identifier)",
            qos: .background,
            target: queue
        )
    }

    public var isAsync: Bool {
        return true
    }

    public func isEnabled(for level: TLogLevel) -> Bool {
        return level <= outputLevel
    }
}
