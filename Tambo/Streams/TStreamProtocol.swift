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
public protocol TStreamProtocol: TLogFilterer {

    var isAsync: Bool {get set}

    /// Identifier for the stream (should be unique)
    var identifier: String {get set}

    /// Log level for this stream. All levels > than this one will be ignored.
    var outputLevel: TLogLevel {get set}

    /// The queue the base stream is serially dispatching to.
    /// - note: you can use the `streamQueue(target:)` method to set the queue to one that
    ///     follows the Tambo convention.
    var queue: DispatchQueue {get set}

    /**
     Any additional metadata that will be added to the `Tlog.context` dictionary.
     - note: use this dictionary to set any additional metadata that the `Tlog` struct
        before is precessed by the stream. This can contain, for example, the OS version,
        app version, a UUID used to group logs messages triggered on the same "session"
        or any additional information, common to every log message, that is usefull to
        give more context.
     */
    var metadata: [String: Any]? {get set}

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
}

extension TStreamProtocol {

    func streamQueue(target q: DispatchQueue? = nil) -> DispatchQueue {
        return DispatchQueue(
            label: "com.tambo.stream.\(identifier)",
            qos: .background,
            target: q
        )
    }

    public func isEnabled(for level: TLogLevel) -> Bool {
        return level <= outputLevel
    }
}
