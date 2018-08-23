//
//  TLogToStringFormatter.swift
//  Tambo
//
//  Created by Massimo Donati on 7/29/18.
//

import Foundation

/**
 The Tambo default formatter.
 This formatter can be used as follows:
    1. Set the format string to feet your needs; or not if the default behavior
        is good enough.
    2. Set the dateFormatter to feet your needs; or not if the default behavior
        is good enough.
 - Tag: T.TLogDefaultStringFormatter
 */
public class TLogStringFormatter: TLogFormatterProtocol {

    /**
     The formate rule this formatter will follow to present the log information.
     - note: The keys are documented in the
     [SLLogFormatKey](xc-source-tag://T.SLLogFormatKey)
     */
    public var logFormat = """
        [D] [L] T S F.f:# - M
        C
        """

    /**
     The date formatter to be used to produce the string value.
     - note: The default one will format the date using `"HH:mm:ss.SSS"`
     */
    public var dateFormatter: DateFormatter

    /// Designated initializer.
    public init(with format: String? = nil) {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        if let format = format {
            logFormat = format
        }
    }

    /**
     Produces a string from a [TLog](x-source-tag://T.TLog) object.
     - parameter log: The TLog object we want to convert into a string.
     - seealso: [TLogToStringFormatterProtocol](x-source-tag://T.TLogToStringFormatterProtocol)
     */
    public func format(_ log: TLog) -> String  {
        var outputString = ""

        logFormat.forEach { ch in
            switch ch {
            case SLLogFormatKey.date.rawValue:
                outputString += dateFormatter.string(from: log.date)
            case SLLogFormatKey.logger.rawValue:
                outputString += log.loggerID
            case SLLogFormatKey.level.rawValue:
                outputString += log.level.name
            case SLLogFormatKey.levelSymbol.rawValue:
                outputString += log.level.symbol
            case SLLogFormatKey.message.rawValue:
                outputString += String(describing: log.message())
            case SLLogFormatKey.thread.rawValue:
                outputString += log.threadName
            case SLLogFormatKey.function.rawValue:
                outputString += log.functionName
            case SLLogFormatKey.file.rawValue:
                outputString += log.fileName
            case SLLogFormatKey.line.rawValue:
                outputString += String(describing: log.lineNumber)
            case SLLogFormatKey.context.rawValue:
                if let contextString = log.contextJSONString {
                    outputString += "\(contextString)"
                }
            default:
                outputString += String(ch)
            }
        }
        return outputString.trimmingCharacters(in: .whitespaces)
    }
}

/**
 Defines all the possible keys supported by
 [TLogToStringFormatterProtocol](x-source-tag://T.TLogToStringFormatterProtocol).
 */
enum SLLogFormatKey: Character {

    /// The time the [TLog](x-source-tag://T.TLog) was originated at.
    case date = "D"

    /// The logger identifier the [TLog](x-source-tag://T.TLog) was originated from.
    case logger = "L"

    /// The level name of the [TLog](x-source-tag://T.TLog) i.e. "info"
    case level = "l"

    /// The level symbol of the [TLog](x-source-tag://T.TLog) i.e. "ℹ️"
    case levelSymbol = "S"

    /// The [TLog](x-source-tag://T.TLog)'s message.
    case message = "M"

    /**
     The thread name the [TLog](x-source-tag://T.TLog) was originate from.
     The possible values are:
        1. "main_thread"
        2. the thread name
        3. the string descritpion of the thread
     */
    case thread = "T"

    /// The function name the [TLog](x-source-tag://T.TLog) was originated from.
    case function = "f"

    /**
     The file name the [TLog](x-source-tag://T.TLog) was originated
     from i.e. `MyFile`
     - note: this doesn't include the file extension.
     */
    case file = "F"

    /// The line number the [TLog](x-source-tag://T.TLog) was originated from.
    case line = "#"

    /// Any additional metadata useful to give more context to the logs.
    case context = "C"
}
