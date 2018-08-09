//
//  TLogToJSONFormatter.swift
//  Tambo
//
//  Created by Massimo Donati on 7/29/18.
//

import Foundation

public class TLogJSONDictionaryFormatter: TLogFormatterProtocol {
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

    /**
     Conformace to the
     [TLogToJSONFormatterProtocol](x-source-tag://T.TLogToJSONFormatterProtocol).
     */
    public func format(_ log: TLog) -> TamboJSONType {
        var json: TamboJSONType = [:]

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
    public var dateFormatter: DateFormatter

    /// Designated initializer.
    public init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
    }

    public func format(_ log: TLog) -> Data {
        var logDict = TLogJSONDictionaryFormatter().format(log)
        if !JSONSerialization.isValidJSONObject(logDict) {
            logDict.jsonify()
        }

        return try! JSONSerialization.data(withJSONObject: logDict)
    }
}
