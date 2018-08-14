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
     The date formatter to be used to produce the string value.
     - note: The default one will format the date using `yyyy-MM-dd HH:mm:ss Z`.
     */
    public var dateFormatter: DateFormatter

    /// Designated initializer.
    public init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    }

    public func dictionary(from log: TLog) -> TJSONType {
        var json: TJSONType = [:]

        json["logger_id"] = log.loggerID
        json["level"] = log.level.name
        json["date"] = dateFormatter.string(from: log.date)
        json["message"] = log.message()
        json["thread"] = log.threadName
        json["function"] = log.functionName
        json["file"] = log.fileName
        json["line"] = log.lineNumber

        if var userInfo = log.userInfo {
            userInfo.jsonify()
            json["user_info"] = userInfo
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
            logDict.jsonify()
        }

        return try! JSONSerialization.data(withJSONObject: logDict)
    }
}
