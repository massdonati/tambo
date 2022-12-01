//
//  Tambo.swift
//  Tambo
//
//  Created by Massimo Donati on 7/24/18.
//

import Foundation
import Combine

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

    lazy var logsPublisher: AnyPublisher<Log, Never> = {
        logStreamPublisher
            .filter({ self.allowedLevels.contains($0.level) && $0.condition })
            .eraseToAnyPublisher()
    }()

    var logStreamPublisher = PassthroughSubject<Log, Never>()

    /**
     Default logger with `com.tambo.default.logger` as identifier
     */
    static public var `default`: Tambo = {
        let logger = Tambo(identifier: "com.tambo.default.logger")
        return logger
    }()

    var allowedLevels: [LogLevel] = .all

    /**
     Designated initializer.
     - parameter identifier: the "name" of the log object. a best practice is to name
        your log instances with a reverse hostname format i.e. "com.tambo.default.logger"
     */
    public init(identifier: String) {
        self.identifier = identifier
    }

    // MARK: - Propagate log to streams

    @usableFromInline
    func propagateLog(
        msgClosure: @escaping () -> Any,
        condition: Bool? = nil,
        level: LogLevel,
        functionName: String,
        filePath: String,
        lineNumber: Int,
        context: [String: LogContextValue]?,
        time: Date = Date()) {
        let log = Log(
            loggerID: self.identifier,
            level: level,
            date: time,
            message: msgClosure,
            condition: condition ?? true,
            threadType: Utility.threadType(),
            functionName: functionName,
            filePath: filePath,
            lineNumber: lineNumber,
            context: context
        )
            logStreamPublisher.send(log)
    }
}

extension Tambo {
    // MARK: - logging methods
    
    @inlinable
    func error(
        _ msgClosure: @autoclosure @escaping () -> Any,
        condition: Bool? = nil,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: [String: LogContextValue]? = nil) {

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

    @inlinable
    func warning(
        _ msgClosure: @autoclosure @escaping () -> Any,
        condition: Bool = true,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: [String: LogContextValue]? = nil) {

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

    @inlinable
    func info(
        _ msgClosure: @autoclosure @escaping () -> Any,
        condition: Bool? = nil,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: [String: LogContextValue]? = nil) {

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

    @inlinable
    func debug(
        _ msgClosure: @autoclosure @escaping () -> Any,
        condition: Bool? = nil,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: [String: LogContextValue]? = nil) {

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

    @inlinable
    func trace(
        _ msgClosure: @autoclosure @escaping () -> Any,
        condition: Bool? = nil,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: [String: LogContextValue]? = nil) {

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
}

extension Tambo {
    func allowLevels(_ levels: [LogLevel]) -> Self {
        allowedLevels = levels
        return self
    }
}
