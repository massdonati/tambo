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
    var dateFormatter: DateFormatter {get set}
}

public class SLLogDefaultFormatter: SLLogFormatterProtocol {

    public var format = """
        [D] T S F.f:# - M
        I
        """

    /// Array of log formatters to apply to messages before they're output
    public var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss.SSS"
        return df
    }()

    public func string(for log: SLLog) -> String {
        var outputString = ""

        format.forEach { ch in
            switch ch {
            case SLLogFormatKey.date.rawValue:
                outputString += dateFormatter.string(from: log.date)
            case SLLogFormatKey.level.rawValue:
                outputString += log.level.name
            case SLLogFormatKey.levelSymbol.rawValue:
                outputString += log.level.symbol
            case SLLogFormatKey.message.rawValue:
                outputString += String(describing: log.message ?? "")
            case SLLogFormatKey.thread.rawValue:
                outputString += log.threadName
            case SLLogFormatKey.function.rawValue:
                outputString += log.functionName
            case SLLogFormatKey.file.rawValue:
                outputString += log.fileName
            case SLLogFormatKey.line.rawValue:
                outputString += String(describing: log.lineNumber)
            case SLLogFormatKey.userInfo.rawValue:
                if let userInfoString = log.userInfoJSONString {
                    outputString += "\(userInfoString)"
                }
            default:
                outputString += String(ch)
            }
        }
        return outputString.trimmingCharacters(in: .whitespaces)
    }
}

enum SLLogFormatKey: Character {
    case date = "D"
    case level = "L"
    case levelSymbol = "S"
    case message = "M"
    case thread = "T"
    case function = "f"
    case file = "F"
    case line = "#"
    case userInfo = "I"
}
