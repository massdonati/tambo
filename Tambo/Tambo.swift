//
//  Tambo.swift
//  Tambo
//
//  Created by Massimo Donati on 7/24/18.
//

import Foundation

/**
 Tambo is the main class to
 */
public final class Tambo {
    private var _async = true
    public var isAsync: Bool {
        get {
            return queue.sync {
                return _async
            }
        }
        set {
            queue.sync {
                _async = newValue
            }
        }
    }
    private(set) var identifier: String
    static var `default`: Tambo = {
        let logger = Tambo(identifier: "com.tambo.default.logger")
        let console = TConsoleStream(
            identifier: "com.tambo.default.consoleStream"
        )
        logger.add(stream: console)
        return logger
    }()

    private let queue: DispatchQueue

    private var streams: [TStreamProtocol] = []

    public init(identifier: String, queue: DispatchQueue? = nil) {
        self.identifier = identifier

        // make sure to have a serial queue.
        self.queue = DispatchQueue(
            label: "com.tambo.\(identifier)",
            qos: .background,
            target: queue
        )
    }

    public func add(stream: TStreamProtocol) {
        queue.sync {
            self.streams.append(stream)
        }
    }

    public func removeAllStreams() {
        queue.sync {
            self.streams = []
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
        functionName: String = #function,
        filePath: String = #file,
        lineNumber: Int = #line,
        userInfo: [String: Any]?,
        time: Date) {

        let propagateToStreamsClosure = {
            let filename = Utility.filename(from: filePath) ?? "FILE_NAME_ERROR"
            let log = TLog(
                loggerID: self.identifier,
                level: level,
                date: time,
                message: msgClosure,
                threadName: Utility.threadName(),
                functionName: functionName,
                fileName: filename,
                lineNumber: lineNumber,
                userInfo: userInfo
            )

            DispatchQueue.concurrentPerform(iterations: self.streams.count) { index in
                let stream = self.streams[index]
                guard stream.isEnabled(for: level) else { return }
                stream.process(log: log)
            }
        }

        if isAsync {
            queue.async(execute: propagateToStreamsClosure)
        } else {
            queue.sync(execute: propagateToStreamsClosure)
        }
    }
}
