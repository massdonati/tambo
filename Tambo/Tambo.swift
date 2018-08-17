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
    2. Create a Tambo instance.
 */
public final class Tambo {
    private(set) var identifier: String
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

    public init(identifier: String) {
        self.identifier = identifier
    }

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
        userInfo: [String: Any]? = nil,
        time: Date = Date()) {

        propagateLog(
            msgClosure: msgClosure,
            level: .verbose,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            userInfo: userInfo,
            time: time
        )
    }

    public func info(
        _ msgClosure: @autoclosure @escaping () -> Any,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        userInfo: [String: Any]? = nil,
        time: Date = Date()) {

        propagateLog(
            msgClosure: msgClosure,
            level: .info,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            userInfo: userInfo,
            time: time
        )
    }

    public func debug(
        _ msgClosure: @autoclosure @escaping () -> Any,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        userInfo: [String: Any]? = nil,
        time: Date = Date()) {

        propagateLog(
            msgClosure: msgClosure,
            level: .debug,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            userInfo: userInfo,
            time: time
        )
    }

    public func error(
        _ msgClosure: @autoclosure @escaping () -> Any,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        userInfo: [String: Any]? = nil,
        time: Date = Date()) {

        propagateLog(
            msgClosure: msgClosure,
            level: .error,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            userInfo: userInfo,
            time: time
        )
    }

    public func warning(
        _ msgClosure: @autoclosure @escaping () -> Any,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        userInfo: [String: Any]? = nil,
        time: Date = Date()) {

        propagateLog(
            msgClosure: msgClosure,
            level: .warning,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            userInfo: userInfo,
            time: time
        )
    }

    private func propagateLog(
        msgClosure: @escaping () -> Any,
        level: TLogLevel,
        functionName: String,
        filePath: String,
        lineNumber: Int,
        userInfo: [String: Any]?,
        time: Date) {

        let log = TLog(
            loggerID: self.identifier,
            level: level,
            date: time,
            message: msgClosure,
            threadName: Utility.threadName(),
            functionName: functionName,
            filePath: filePath,
            lineNumber: lineNumber,
            userInfo: userInfo
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
