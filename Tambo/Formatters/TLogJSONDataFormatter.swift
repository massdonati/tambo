//
//  TLogToJSONFormatter.swift
//  Tambo
//
//  Created by Massimo Donati on 7/29/18.
//

import Foundation

public protocol TLogToDictConversionProtocol {
    func dictionary(from log: TLog) -> TJSONType
}

public class TLogToJSONConverter: TLogToDictConversionProtocol {

    /**
     The date formatter to be used to produce the string value of the log object's date.
     */
    public let dateFormatter: DateFormatter

    /**
     Convenience initializer.
     - note: configures the dateFormatter to use `yyyy-MM-dd HH:mm:ss Z`.
     */
    public convenience init() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        self.init(dateFormatter: formatter)
    }

    /**
     Designated initializer
     - parameter dateFormatter: the date formatter to be used to format the timestamp
        of the log object.
     */
    public init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }

    public func dictionary(from log: TLog) -> TJSONType {
        var json: TJSONType = [
            "logger_id": log.loggerID,
            "level": log.level.name,
            "date": dateFormatter.string(from: log.date),
            "message": log.message(),
            "thread": log.threadName,
            "function": log.functionName,
            "file": log.fileName,
            "line": log.lineNumber
        ]

        if var ctx = log.context {
            ctx.makeJsonEncodable()
            json["context"] = ctx
        }

        return json
    }
}

public class TLogJSONDataFormatter: TLogFormatterProtocol {
    public typealias FormattedType = Data
    public var logToDictConverter: TLogToDictConversionProtocol

    /// Designated initializer.
    public init(with logConverter: TLogToDictConversionProtocol? = nil) {
        if let converter = logConverter {
            logToDictConverter = converter
        } else {
            logToDictConverter = TLogToJSONConverter()
        }
    }

    public func format(_ log: TLog) -> Data {
        var logDict = logToDictConverter.dictionary(from: log)
        if !JSONSerialization.isValidJSONObject(logDict) {
            logDict.makeJsonEncodable()
        }

        return try! JSONSerialization.data(withJSONObject: logDict, options: .sortedKeys)
    }
}
