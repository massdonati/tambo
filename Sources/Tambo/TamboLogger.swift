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
public final class TamboLogger {

    /// A string that identifies uniquely the logger instance
    let identifier: String

    public var logPublisher: AnyPublisher<Log, Never> {
        logStreamPublisher.eraseToAnyPublisher()
    }

    let logStreamPublisher = PassthroughSubject<Log, Never>()

    /**
     Default logger with `com.tambo.default.logger` as identifier
     */
    static public var `default`: TamboLogger = {
        let logger = TamboLogger(identifier: "com.tambo.default.logger")
        return logger
    }()

    /**
     Designated initializer.
     - parameter identifier: the "name" of the log object. a best practice is to name
        your log instances with a reverse hostname format i.e. "com.tambo.default.logger"
     */
    public init(identifier: String) {
        self.identifier = identifier
    }

    // MARK: - logging methods



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
            guard condition == nil || condition == true else { return }
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
            logStreamPublisher.send(log)
    }
}

extension TamboLogger {

//    /**
//     Adds the [stream](x-source-tag://T.TStreamProtocol) to the log streams.
//     - note: Although the framework doesn't enforce the streams to have unique identifiers
//        it is definitely a best practice in order to uniquely identify a where a log
//        message was generated from.
//     */
//    public func subscribe<T>(stream: T) -> Self where T: Subscriber, T.Input == Log, T.Failure == Never {
//        logStreamPublisher.subscribe(stream)
//        return self
//    }



    
}
