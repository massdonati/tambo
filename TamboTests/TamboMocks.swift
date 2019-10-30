//
//  TamboMocks.swift
//  Tambo
//
//  Created by Massimo Donati on 8/9/18.
//

import Foundation
@testable import Tambo

class JSONConverterMock: TLogToDictConversionProtocol {
    var jsonDict: TJSONType = [:]
    func dictionary(from log: TLog) -> TJSONType {
        return jsonDict
    }
}

class StreamMock: TStreamProtocol {
    var metadata: [String : Any]?
    public var filters: TAtomicWrite<[TFilterClosure]> = TAtomicWrite(wrappedValue: [])
    var isAsync: Bool = true
    var identifier: String = ""
    var outputLevel: TLogLevel = .debug
    var queue: DispatchQueue = DispatchQueue(label: "")
    var processClosure: ((TLog) -> Void)? = nil
    var shouldFilterOutClosure: ((TLog) -> Bool)? = nil

    func process(_ log: TLog) {
        processClosure?(log)
    }

    public func should(filterOut log: TLog) -> Bool {
        return shouldFilterOutClosure?(log) ?? false
    }
}

class FormattableStreamMock: TStreamFormattable {
    var metadata: [String : Any]?
    public var filters: TAtomicWrite<[TFilterClosure]> = TAtomicWrite(wrappedValue: [])
    var logFormatter = FormatterMock()
    var isAsync: Bool = true
    var identifier: String = ""
    var outputLevel: TLogLevel = .verbose
    var queue: DispatchQueue = DispatchQueue(label: "")
    var outputLogClosure: (TLog, String) -> Void = {_,_ in}

    func output(log: TLog, formattedLog: String) {
        outputLogClosure(log, formattedLog)
    }
}

class FormatterMock: TLogFormatterProtocol {
    var formattedLogString: String?
    typealias FormattedType = String

    func format(_ log: TLog) -> String {
        return formattedLogString ?? ""
    }
}

let logMock = TLog(loggerID: "test",
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
    level: TLogLevel = .info,
    date: Date = Date(),
    message: @escaping (() -> Any) = { return "" },
    condition: Bool = true,
    threadName: String = "main",
    functionName: String = "somefunction",
    filePath: String = "path",
    lineNumber: Int = 0,
    context: [String: Any]? = nil) -> TLog {

        return TLog(
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
