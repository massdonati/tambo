//
//  SLLogFormatterProtocol.swift
//  SwiftyLogger
//
//  Created by Massimo Donati on 7/23/18.
//

import Foundation

public enum SLLogFormatterOption {
    case `default`, custom(SLLogFormatterProtocol)
}

public protocol SLLogFormatterProtocol {
    /**
     Formats the log details into a string.
     - parameter logDetails: The log details to convert into a string.
     - returns: The formatted string ready for output.
     */
    func string(for log: SLLog) -> String
}

class SLLogDefaultFormatter: SLLogFormatterProtocol {
    /// Array of log formatters to apply to messages before they're output
    var dateFormatter = DateFormatter()
    func string(for log: SLLog) -> String {
        let time = dateFormatter.string(from: log.date)
        let levelSymbol = log.level.symbol
        let levelName = log.level.name.capitalized

        var outputString = "\(time) \(levelSymbol) \(levelName)"
        if let message = log.message {
            outputString += " \(String(describing: message))"
        }
        outputString += " \(log.threadName)"
        outputString += " \(log.fileName).\(log.functionName):\(log.lineNumber)"
        if let userInfoString = log.userInfoJSONString {
            outputString += "\n\(userInfoString)"
        }
        return outputString
    }
}
