//
//  TLogToJSONFormatter.swift
//  Tambo
//
//  Created by Massimo Donati on 7/29/18.
//

import Foundation

/// - Tag: T.TLogToJSONFormatterProtocol
protocol TLogToJSONFormatterProtocol: TLogFormatterProtocol {
    /**
     Formats the log details into a string.
     - parameter log: The [TLog](x-source-tag://T.TLog) to convert into a valid
        JSON serializable dictionary.
     - returns: A valid JSON serializable dictionary. That is saying that
        JSONSerialization.isValidJSONObject(dict) will return true.
     */
    func json(for log: TLog) -> TamboJSONType

    /**
     Helper method to get a Data object back.
     - parameter log: the [TLog](x-source-tag://T.TLog) object to convert to
        JSON data.
     - returns: A serialized jsonObject data using .utf8 encoding.
     */
    func jsonObject(for log: TLog) -> Data
}

extension TLogToJSONFormatterProtocol {
    public func format(_ log: TLog) -> Any {
        return json(for: log)
    }
}

public class TLogDefaultJSONFormatter: TLogToJSONFormatterProtocol {
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
    public func json(for log: TLog) -> TamboJSONType {
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

    /**
     Conformace to the
     [TLogToJSONFormatterProtocol](x-source-tag://T.TLogToJSONFormatterProtocol).
     - note: is subclasses will not return a valid JSONObject from the
        json(for:) method this is also safe because it calls `jsonify`
        on the returned dictionary which is guaranteed to be converted in a
        valid JSON object.
     - note: uses `JSONSerialization.data(withJSONObject:)`.
     */
    public func jsonObject(for log: TLog) -> Data {
        var jsonDict = json(for: log)

        if !JSONSerialization.isValidJSONObject(jsonDict) {
            jsonDict.jsonify()
        }

        return try! JSONSerialization.data(withJSONObject: jsonDict)
    }
}
