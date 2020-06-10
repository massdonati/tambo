//
//  TLogToJSONFormatter.swift
//  Tambo
//
//  Created by Massimo Donati on 7/29/18.
//

import Foundation

public protocol LogToDictionaryConverting {
    func dictionary(from log: Log) -> TJSONType
}

public class TLogToJSONConverter: LogToDictionaryConverting {

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

    public func dictionary(from log: Log) -> TJSONType {
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
            ctx.makeValidJsonObject()
            json["context"] = ctx
        }

        return json
    }

    public func string(from log: Log,
                       writingOption: JSONSerialization.WritingOptions = .sortedKeys) throws -> String {
        var dict = dictionary(from: log)
        dict.makeValidJsonObject()

        let data = try JSONSerialization.data(withJSONObject: dict, options: writingOption)

        guard let formattedString = String(data: data, encoding: .utf8) else {
            throw "can't format log"
        }

        return formattedString
    }
}

public class LogJSONFormatter: LogFormatterProtocol {
    public typealias FormattedType = Data
    public var logToDictConverter: LogToDictionaryConverting

    /// Designated initializer.
    public init(with logConverter: LogToDictionaryConverting? = nil) {
        if let converter = logConverter {
            logToDictConverter = converter
        } else {
            logToDictConverter = TLogToJSONConverter()
        }
    }

    public func format(_ log: Log) -> Data {
        var logDict = logToDictConverter.dictionary(from: log)
        if !JSONSerialization.isValidJSONObject(logDict) {
            logDict.makeValidJsonObject()
        }

        return try! JSONSerialization.data(withJSONObject: logDict, options: .sortedKeys)
    }
}

extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
