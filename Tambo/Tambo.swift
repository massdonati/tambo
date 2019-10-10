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
        appropriate [streams](x-source-tag://T.TStreamProtocol).
 - note: Tambo already provides `TConsoleStream` and `TOSLogStream`
 */
public final class Tambo {
    private(set) var identifier: String

    /**
     Default logger with `com.tambo.default.logger` as identifier
     */
    static public var `default`: Tambo = {
        let logger = Tambo(identifier: "com.tambo.default.logger")
        let console = TConsoleStream(
            identifier: "com.tambo.default.consoleStream",
            printMode: .print
        )
        logger.add(stream: console)
        return logger
    }()

    private var protectedStreams = TThreadProtector([TStreamProtocol]())

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
    public func add(stream: TStreamProtocol) {
        protectedStreams.write { streams in
            streams.append(stream)
        }
    }

    public func removeAllStreams() {
        protectedStreams.write { streams in
            streams.removeAll()
        }
    }

    // MARK: - logging methods

    public func verbose(
        _ msgClosure: @autoclosure @escaping () -> Any,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: [String: Any]? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            level: .verbose,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }

    public func info(
        _ msgClosure: @autoclosure @escaping () -> Any,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: [String: Any]? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            level: .info,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }

    public func debug(
        _ msgClosure: @autoclosure @escaping () -> Any,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: [String: Any]? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            level: .debug,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }

    public func error(
        _ msgClosure: @autoclosure @escaping () -> Any,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: [String: Any]? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            level: .error,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }

    public func warning(
        _ msgClosure: @autoclosure @escaping () -> Any,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: [String: Any]? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            level: .warning,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }

    // MARK: - Propagate log to streams

    private func propagateLog(
        msgClosure: @escaping () -> Any,
        level: TLogLevel,
        functionName: String,
        filePath: String,
        lineNumber: Int,
        context: [String: Any]?,
        time: Date = Date()) {

        let log = TLog(
            loggerID: self.identifier,
            level: level,
            date: time,
            message: msgClosure,
            threadName: Utility.threadName(),
            functionName: functionName,
            filePath: filePath,
            lineNumber: lineNumber,
            context: context
        )
        protectedStreams.read { streams in
            DispatchQueue
                .concurrentPerform(iterations: streams.count) { index in
                    let stream = streams[index]
                    guard
                        stream.isEnabled(for: level),
                        stream.should(filter: log) == false
                        else { return }

                    stream.process(log)
            }
        }
    }
}
