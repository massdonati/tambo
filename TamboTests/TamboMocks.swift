//
//  TamboMocks.swift
//  Tambo
//
//  Created by Massimo Donati on 8/9/18.
//

import Foundation
@testable import Tambo

class JSONConverterMock: LogToDictConversionProtocol {
    var jsonDict: TJSONType = [:]
    func dictionary(from log: Log) -> TJSONType {
        return jsonDict
    }
}

class StreamMock: StreamProtocol {
    var metadata: [String : Any]?
    public var filters: TAtomicWrite<[FilterClosure]> = TAtomicWrite(wrappedValue: [])
    var isAsync: Bool = true
    var identifier: String = ""
    var outputLevel: LogLevel = .debug
    var queue: DispatchQueue = DispatchQueue(label: "")
    var processClosure: ((Log) -> Void)? = nil
    var shouldFilterOutClosure: ((Log) -> Bool)? = nil

    func process(_ log: Log) {
        processClosure?(log)
    }

    public func should(filterOut log: Log) -> Bool {
        return shouldFilterOutClosure?(log) ?? false
    }
}

class FormattableStreamMock: StreamFormattable {
    var metadata: [String : Any]?
    public var filters: TAtomicWrite<[FilterClosure]> = TAtomicWrite(wrappedValue: [])
    var logFormatter = FormatterMock()
    var isAsync: Bool = true
    var identifier: String = ""
    var outputLevel: LogLevel = .trace
    var queue: DispatchQueue = DispatchQueue(label: "")
    var outputLogClosure: (Log, String) -> Void = {_,_ in}

    func output(log: Log, formattedLog: String) {
        outputLogClosure(log, formattedLog)
    }
}

class FormatterMock: LogFormatterProtocol {
    var formattedLogString: String?
    typealias FormattedType = String

    func format(_ log: Log) -> String {
        return formattedLogString ?? ""
    }
}

let logMock = Log(loggerID: "test",
               level: .info,
               date: Date(),
               message: { return "" },
               condition: true,
               threadName: "main",
               functionName: "",
               filePath: "nil",
               lineNumber: 0,
               context: ["hello": "world"])

class SyncConcurrentDispatcher: ConcurrentDispatcherProtocol {
    func concurrentPerform(iterations: Int, execute work: (Int) -> Void) {
        (0..<iterations).forEach(work)
    }
}

enum Fixture {
    static func mockTLog(loggerID: String = "test",
    level: LogLevel = .info,
    date: Date = Date(),
    message: @escaping (() -> Any) = { return "" },
    condition: Bool = true,
    threadName: String = "main",
    functionName: String = "somefunction",
    filePath: String = "path",
    lineNumber: Int = 0,
    context: [String: Any]? = nil) -> Log {

        return Log(
            loggerID: loggerID,
            level: level,
            date: date,
            message: message,
            condition: condition,
            threadName: threadName,
            functionName: functionName,
            filePath: filePath,
            lineNumber: lineNumber,
            context: context
        )
    }
}
