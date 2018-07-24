//
//  SLLogger.swift
//  SwiftyLogger
//
//  Created by Massimo Donati on 7/24/18.
//

import Foundation

public final class SLLogger {
    private(set) var identifier: String
    static var shared: SLLogger = {
        return SLLogger(identifier: "com.swiftylogger.sllogger")
    }()

    private(set) var queue: DispatchQueue

    open var destinations: [SLDestinationProtocol] = []

    public init(identifier: String, queue: DispatchQueue? = nil) {
        self.identifier = identifier
        self.queue = queue ?? DispatchQueue(label: "com.swiftylogger.sllogger.queue",
                                            qos: .background)
    }

    // MARK: - logging methods

    /// Log something at the Verbose log level.
    ///
    /// - Parameters:
    ///     - closure:      A closure that returns the object to be logged.
    ///     - functionName: Normally omitted **Default:** *#function*.
    ///     - fileName:     Normally omitted **Default:** *#file*.
    ///     - lineNumber:   Normally omitted **Default:** *#line*.
    ///     - userInfo:     Dictionary for adding arbitrary data to the log message, can be used by filters/formatters etc
    ///
    /// - Returns:  Nothing.
    ///
    public func verbose(
        _ message: @autoclosure @escaping () -> Any?,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        userInfo: [String: Any]? = nil,
        time: Date = Date()) {

        propagateLog(
            message: message,
            .verbose,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            userInfo: userInfo,
            time: time
        )
    }

    public func info(
        _ message: @autoclosure @escaping () -> Any?,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        userInfo: [String: Any]? = nil,
        time: Date = Date()) {

        propagateLog(
            message: message,
            .info,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            userInfo: userInfo,
            time: time
        )
    }


    public func debug(
        _ message: @autoclosure @escaping () -> Any?,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        userInfo: [String: Any]? = nil,
        time: Date = Date()) {

        propagateLog(
            message: message,
            .debug,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            userInfo: userInfo,
            time: time
        )
    }

    public func error(
        _ message: @autoclosure @escaping () -> Any?,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        userInfo: [String: Any]? = nil,
        time: Date = Date()) {

        propagateLog(
            message: message,
            .error,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            userInfo: userInfo,
            time: time
        )
    }

    public func warning(
        _ message: @autoclosure @escaping () -> Any?,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        userInfo: [String: Any]? = nil,
        time: Date = Date()) {

        propagateLog(
            message: message,
            .warning,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            userInfo: userInfo,
            time: time
        )
    }

    private func propagateLog(
        message: () -> Any?,
        _ level: SLLogLevel,
        functionName: String = #function,
        filePath: String = #file,
        lineNumber: Int = #line,
        userInfo: [String: Any]?,
        time: Date) {
        let filename = Utility.filename(from: filePath) ?? "FILE_NAME_ERROR"
        let log = SLLog(level: level,
                        date: time,
                        message: message(),
                        threadName: Utility.threadName(),
                        functionName: functionName,
                        fileName: filename,
                        lineNumber: lineNumber,
                        userInfo: userInfo)

        destinations.forEach { dest in
            guard dest.isEnabled(for: level) else { return }
            dest.process(log: log)
        }
    }
}
