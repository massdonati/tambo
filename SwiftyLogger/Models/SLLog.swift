//
//  SLLog.swift
//  SwiftyLogger
//
//  Created by Massimo Donati on 7/23/18.
//

import Foundation

/// Data structure to hold all info about a log message, passed to destination classes
public struct SLLog {

    /// Log level required to display this log
    public let level: SLLogLevel

    /// Date this log was sent
    public let date: Date

    /// The log message to display
    public let message: Any?

    public let threadName: String

    /// Name of the function that generated this log
    public let functionName: String

    /// Name of the file the function exists in
    public let fileName: String

    /// The line number that generated this log
    public let lineNumber: Int

    /**
     Dictionary to store miscellaneous data about the log, can be used by
     formatters and filters etc. Please prefix any keys to help avoid
     collissions.
     */
    public let userInfo: [String: Any]?

    public var userInfoJSONString: String? {
        guard var uInfo = userInfo else { return nil }

        uInfo.jsonify()

        guard JSONSerialization.isValidJSONObject(uInfo) else {
            return String(describing: uInfo)
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: uInfo,
                                                  options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch {
            print("""
                SwiftyLogger could not transform the userInfo into JSON \
                \(uInfo). \(error)
                """)
            return String(describing: uInfo)
        }

    }
}
