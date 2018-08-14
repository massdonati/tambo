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
    var isAsync: Bool = true
    var identifier: String = ""
    var outputLevel: TLogLevel = .debug
    var queue: DispatchQueue = DispatchQueue(label: "")
    var processClosure: ((TLog) -> Void)? = nil
    var shouldProcessClosure: ((TLog) -> Bool)? = nil

    func process(_ log: TLog) {
        processClosure?(log)
    }

    func should(process log: TLog) -> Bool {
        return shouldProcessClosure?(log) ?? true
    }
}

class FormattableStreamMock: TStreamFormattable {
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
               threadName: "main",
               functionName: "",
               fileName: "nil",
               lineNumber: 0,
               userInfo: ["hello": "world"])
