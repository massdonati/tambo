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
    func json(for log: TLog) -> JSONType

    /**
     Helper method to get a Data object back.
     - parameter log: the [TLog](x-source-tag://T.TLog) object to convert to
        JSON.
     - returns: A serialized jsonObject result of the
        `JSONSerialization.data(withJSONObject: jsonDict)` api.
     - note: this method doesn't throw because it calls json(for:) under the
        hood which by design returns a valid JSON dictionary.
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
    public var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return df
    }()

    /**
     Conformace to the
     [TLogToJSONFormatterProtocol](x-source-tag://T.TLogToJSONFormatterProtocol).
     */
    func json(for log: TLog) -> JSONType {
        var json: JSONType = [:]

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
            json["metadata"] = userInfo
        }

        return json
    }

    /**
     Conformace to the
     [TLogToJSONFormatterProtocol](x-source-tag://T.TLogToJSONFormatterProtocol).
     */
    func jsonObject(for log: TLog) -> Data {
        let jsonDict = json(for: log)

        precondition(JSONSerialization.isValidJSONObject(jsonDict), """
            Something went wrong, jsonDict is supposed to return a valid \
            serializable object. Please open an issue in the github repo with \
            as many info as you can.
            """)

        return try! JSONSerialization.data(withJSONObject: jsonDict)
    }
}
