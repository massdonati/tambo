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
    var identifier: String = "com.tambo.logger"
    /// The queue in which the logs will be processed and dispatched onto.
    var processingQueue: DispatchQueue? = .init(label: "com.tambo.logger.queue", qos: .background)
    /**
     The publisher for the logs.
     All logs published are already filtered based on the
     */
    lazy var logsPublisher: AnyPublisher<Event, Never> = {
        let levelFilter: (Event) -> Bool = { [allowedLevels] log in
            allowedLevels.contains(log.level)
        }

        if let processingQueue {
            return _logsPublisher
                .receive(on: processingQueue)
                .filter(levelFilter)
                .eraseToAnyPublisher()
        } else {
            return _logsPublisher
                .filter(levelFilter)
                .eraseToAnyPublisher()
        }
    }()

    /// Internal log publisher
    let _logsPublisher = PassthroughSubject<Event, Never>()

    /**
     the levels that are allowed for this logger instance. the default value
     is `.all` meaning "very chatty".
     */
    var allowedLevels: [LogLevel] = .all

    /**
     Designated initializer.
     - parameter identifier: the "name" of the log object. a best practice is to name
        your log instances with a reverse hostname format i.e. "com.tambo.logger"
     */
    public init(identifier: String) {
        self.identifier = identifier
    }

    // MARK: - Propagate log to streams

    @usableFromInline
    func propagateLog(
        msgClosure: @escaping () -> String,
        level: LogLevel,
        functionName: String,
        filePath: String,
        lineNumber: Int,
        context: [String: LogContextValue]?,
        time: Date = Date()) {
        let log = Event(
            loggerID: self.identifier,
            level: level,
            date: time,
            message: msgClosure,
            threadType: Utility.threadType(),
            functionName: functionName,
            filePath: filePath,
            lineNumber: lineNumber,
            context: context
        )
            _logsPublisher.send(log)
    }
}

extension Tambo {
    public func processing(_ system: TamboDeliverySystem) -> Self {
        processingQueue = system.queue
        return self
    }

    public func allowingLevels(_ levels: LogLevel...) -> Self {
        return allowingLevels(levels)
    }

    public func allowingLevels(_ levels: [LogLevel]) -> Self {
        allowedLevels = levels
        return self
    }
}
