//
//  Log.swift
//  Tambo
//
//  Created by Massimo Donati on 7/23/18.
//

import Foundation

/**
 Data structure to hold all info about a log, passed to stream classes.
 This struct is generated anytime the user calls any logging api i.e.
 Tambo.default.info("log message", ["user_id": "123"])

 - note: if you need a valid JSON disctionary you can use the `jsonObject` property,
    if you need the encoded `Data` you can use the `jsonData` one.
 */
public struct Log {

    /// a unique identifier of the log instance
    public let id = UUID()

    /// the Logger identifier this object was originated from.
    public let loggerID: String

    /// The level of the log i.e. `.info`.
    public let level: LogLevel

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
     this condition is set by the user of the `Tambo` apis and is used to provide to the
     user an additional level of filtering. The log message will be discarded if
     `condition` is false.
     For Example you could write
     ```
     func complete(success: Bool) {
        log.error("The opration wasn't successfull", condition: success == false)
        ...
     }
     ```
     */
    public let condition: Bool

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
    public internal(set) var context: [String: LogContextValue]?

    init(loggerID: String, level: LogLevel, date: Date, message: @autoclosure @escaping () -> Any, condition: Bool, threadName: String, functionName: String, filePath: String, lineNumber: Int, context: [String : LogContextValue]?) {

        self.loggerID = loggerID
        self.level = level
        self.date = date
        self.message = message
        self.condition = condition
        self.threadName = threadName
        self.functionName = functionName
        self.filePath = filePath
        self.lineNumber = lineNumber
        self.context = context
    }
}
