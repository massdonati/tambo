//
//  TLog.swift
//  Tambo
//
//  Created by Massimo Donati on 7/23/18.
//

import Foundation

/**
 Data structure to hold all info about a log, passed to stream classes.
 This struct is generated anytime the user calls any logging api i.e.
 Tambo.default.info("log message", ["user_id": "123"])
 */
public struct TLog {

    /// the Logger identifier this object was originated from.
    public let loggerID: String

    /// The level of the log i.e. `.info`.
    public let level: TLogLevel

    /// The time this log was originated at.
    public let date: Date

    /**
     The log message to display.
     - note: Since the message can be costly to compute, think about
        interpolated strings with array mappings, this is a closure so we can
        move that computation to a background thread that will alleviate
        the processing at the caller side.
     */
    public let message: (() -> Any)

    /**
     The thread name the this log was originate from.
     The possible values are:
        1. "main_thread"
        2. "bg_thread_\(thread_id)"
     */
    public let threadName: String

    /// The name of the function that generated this log.
    public let functionName: String

    /// The name of the file the log was generated from, computed from the filePath.
    public var fileName: String {
        return Utility.filename(from: filePath) ?? ""
    }

    /// The full path of the file the log was generated from.
    public let filePath: String

    /// The line number that generated this log.
    public let lineNumber: Int

    /// Dictionary to store useful metadata about the log.
    public let context: [String: Any]?

    /**
     Computed property to convert the userInfo dictionary into a `prettyPrinted`
     string.
     - note: Uses `JSONSerialization` under the hood but it doesn't `throw`
        eny exception thanks to the `jsonify` `Disctionary` extension method.
     */
    public var contextJSONString: String? {
        guard var info = context else { return nil }

        info.makeValidJsonObject()

        do {
            let data = try JSONSerialization.data(withJSONObject: info,
                                                  options: .prettyPrinted)
            return String(data: data, encoding: .utf8)?
                .replacingOccurrences(of: "\\", with: "")
        } catch {
            return nil
        }
    }
}
