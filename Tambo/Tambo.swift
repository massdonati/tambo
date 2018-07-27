//
//  Tambo.swift
//  Tambo
//
//  Created by Massimo Donati on 7/24/18.
//

import Foundation

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
        return Tambo(identifier: "com.swiftylogger.sllogger")
    }()

    private let queue: DispatchQueue

    private var destinations: [TStreamProtocol] = []

    public init(identifier: String, queue: DispatchQueue? = nil) {
        self.identifier = identifier

        // make sure to have a serial queue.
        self.queue = DispatchQueue(label: "com.swiftylogger.\(identifier)",
            qos: .background,
            target: queue)
    }

    public func addDestination(_ destination: TStreamProtocol) {
        queue.sync {
            self.destinations.append(destination)
        }
    }

    public func removeAllDestinations() {
        queue.sync {
            self.destinations = []
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
            .verbose,
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
            .info,
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
            .debug,
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
            .error,
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
            .warning,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            userInfo: userInfo,
            time: time
        )
    }

    private func propagateLog(
        msgClosure: @escaping () -> Any,
        _ level: TLogLevel,
        functionName: String = #function,
        filePath: String = #file,
        lineNumber: Int = #line,
        userInfo: [String: Any]?,
        time: Date) {

        let propagateClosure = {
            let filename = Utility.filename(from: filePath) ?? "FILE_NAME_ERROR"
            let log = TLog(loggerID: self.identifier,
                            level: level,
                            date: time,
                            message: msgClosure,
                            threadName: Utility.threadName(),
                            functionName: functionName,
                            fileName: filename,
                            lineNumber: lineNumber,
                            userInfo: userInfo)
            self.destinations.forEach { dest in
                guard dest.isEnabled(for: level) else { return }
                dest.process(log: log)
            }
        }

        if isAsync {
            queue.async(execute: propagateClosure)
        } else {
            queue.sync(execute: propagateClosure)
        }
    }
}
