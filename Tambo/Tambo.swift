//
//  Tambo.swift
//  Tambo
//
//  Created by Massimo Donati on 7/24/18.
//

import Foundation

/**
 Tambo is the main class that the user will use to start logging.
 It provides two ways to log:
    1. A `default`, singleton, logger instance with a console stream already
        cofigured in it.
    2. Create a Tambo instance. In this case the user is also required to add the
        appropriate [streams](x-source-tag://T.StreamProtocol).
 - note: Tambo already provides `TConsoleStream` and `TOSLogStream`
 */
public final class Tambo {

    /// A string that identifies uniquely the logger instance
    let identifier: String

    /**
     Entity responsible to concurrently dispatch the processing of a log struct
     to the streams registered with the Tambo instance.
     */
    var concurrentDispatcher: ConcurrentDispatcherProtocol = ConcurrentDispatcher()
    /**
     Default logger with `com.tambo.default.logger` as identifier
     */
    static public var `default`: Tambo = {
        let logger = Tambo(identifier: "com.tambo.default.logger")
        let console = ConsoleStream(
            identifier: "com.tambo.default.consoleStream",
            printMode: .print
        )
        logger.add(stream: console)
        return logger
    }()

    @AtomicWrite var streams: [StreamProtocol] = []

    /**
     Designated initializer.
     - parameter identifier: the "name" of the log object. a best practice is to name
        your log instances with a reverse hostname format i.e. "com.tambo.default.logger"
     */
    public init(identifier: String) {
        self.identifier = identifier
    }

    /**
     Adds the [stream](x-source-tag://T.TStreamProtocol) to the log streams.
     - note: Although the framework doesn't enforce the streams to have unique identifiers
        it is definitely a best practice in order to uniquely identify a where a log
        message was generated from.
     */
    public func add(stream: StreamProtocol) {
        _streams.mutate { $0.append(stream) }
    }

    public func removeAllStreams() {
        _streams.mutate { $0.removeAll() }
    }

    // MARK: - logging methods

    /**
    Logs a message with a `error` log level
    - parameter msgClosure: the log message or anything that the user needs to
        log investigate.
    - parameter condition: if false this log message would not be processed
    - parameter functionName: the name of the function the log api was invoked
        from.
    - parameter filePath: the file path the log api was invoked from.
    - parameter lineNumber: the line number the log api is situated.
    - parameter context: any additional information that the user needs to
        provide more context to a logging event
    */
    public func error(
        _ msgClosure: @autoclosure @escaping () -> Any,
        condition: Bool? = nil,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: [String: Any]? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            condition: condition,
            level: .error,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }

    /**
    Logs a message with a `warning` log level
    - parameter msgClosure: the log message or anything that the user needs to
        log investigate.
    - parameter condition: if false this log message would not be processed
    - parameter functionName: the name of the function the log api was invoked
        from.
    - parameter filePath: the file path the log api was invoked from.
    - parameter lineNumber: the line number the log api is situated.
    - parameter context: any additional information that the user needs to
        provide more context to a logging event
    */
    public func warning(
        _ msgClosure: @autoclosure @escaping () -> Any,
        condition: Bool = true,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: [String: Any]? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            condition: condition,
            level: .warning,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }

    /**
    Logs a message with a `info` log level
    - parameter msgClosure: the log message or anything that the user needs to
        log investigate.
    - parameter condition: if false this log message would not be processed
    - parameter functionName: the name of the function the log api was invoked
        from.
    - parameter filePath: the file path the log api was invoked from.
    - parameter lineNumber: the line number the log api is situated.
    - parameter context: any additional information that the user needs to
        provide more context to a logging event
    */
    public func info(
        _ msgClosure: @autoclosure @escaping () -> Any,
        condition: Bool? = nil,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: [String: Any]? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            condition: condition,
            level: .info,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }

    /**
    Logs a message with a `debug` log level
    - parameter msgClosure: the log message or anything that the user needs to
        log investigate.
    - parameter condition: if false this log message would not be processed
    - parameter functionName: the name of the function the log api was invoked
        from.
    - parameter filePath: the file path the log api was invoked from.
    - parameter lineNumber: the line number the log api is situated.
    - parameter context: any additional information that the user needs to
        provide more context to a logging event
    */
    public func debug(
        _ msgClosure: @autoclosure @escaping () -> Any,
        condition: Bool? = nil,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: [String: Any]? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            condition: condition,
            level: .debug,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }

    /**
     Logs a message with a `verbose` log level
     - parameter msgClosure: the log message or anything that the user needs to
         log investigate.
     - parameter condition: if false this log message would not be processed
     - parameter functionName: the name of the function the log api was invoked
         from.
     - parameter filePath: the file path the log api was invoked from.
     - parameter lineNumber: the line number the log api is situated.
     - parameter context: any additional information that the user needs to
         provide more context to a logging event
     */
    public func trace(
        _ msgClosure: @autoclosure @escaping () -> Any,
        condition: Bool? = nil,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: [String: Any]? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            condition: condition,
            level: .trace,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }

    // MARK: - Propagate log to streams

    private func propagateLog(
        msgClosure: @escaping () -> Any,
        condition: Bool? = nil,
        level: LogLevel,
        functionName: String,
        filePath: String,
        lineNumber: Int,
        context: [String: Any]?,
        time: Date = Date()) {

        let log = Log(
            loggerID: self.identifier,
            level: level,
            date: time,
            message: msgClosure,
            condition: condition ?? true,
            threadName: Utility.threadName(),
            functionName: functionName,
            filePath: filePath,
            lineNumber: lineNumber,
            context: context
        )
        concurrentDispatcher
            .concurrentPerform(iterations: streams.count) { index in
                self.processLog(log, to: streams[index])
        }
    }

    func processLog(_ log: Log, to stream: StreamProtocol) {
        guard
            log.condition,
            stream.isEnabled(for: log.level),
            stream.should(filterOut: log) == false else { return }
        
        var editableLog = log
        if let metadata = stream.metadata {
            // injecting stream's metadata
            var currentContext = editableLog.context ?? [:]
            currentContext["metadata"] = metadata
            editableLog.context = currentContext
        }

        stream.process(editableLog)
    }
}
