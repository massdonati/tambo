//
//  Log+JSON.swift
//  Tambo
//
//  Created by Massimo Donati on 10/15/19.
//

import Foundation

extension Log {

    /**
     - returns: A valid encoded JSON Data. nil if
        `JSONSerialization.data(withJSONObject:options:)` failed.
     - note: uses `jsonObject` under the hood.
     */
    public var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: jsonObject,
                                           options: .prettyPrinted)
    }

    /**
     - returns: A valid JSON dictionary representing the log struct.
     - note: valid means that `JSONSerialization.isValidJSONObject(log.jsonObject) == true`
     */
    public var jsonObject: [String: Any] {
        var dict: [String: Any] = [
            "logger_id": loggerID,
            "level": level.name,
            "date": date.timeIntervalSince1970,
            "tread": threadName,
            "function": functionName,
            "file": fileName,
            "file_path": filePath,
            "line": lineNumber
        ]

        if var ctx = context {
            ctx.makeValidJsonObject()
            dict["context"] = ctx
        }

        let msg = message()
        let isMessageValidJSON = JSONSerialization.isValidJSONObject(msg) ||
            JSONSerialization.isValidJSONObject([msg])

        dict["message"] = isMessageValidJSON ? msg : JSON.validObject(from: msg)

        return dict
    }
}
