//
//  TLogToStringFormatter.swift
//  Tambo
//
//  Created by Massimo Donati on 7/29/18.
//

import Foundation

/**
 - Tag: T.TLogToStringFormatterProtocol
 */
protocol TLogToStringFormatterProtocol: TLogFormatterProtocol {
    /**
     Formats the log details into a string.
     - parameter log: The [TLog](x-source-tag://T.TLog) to convert into a string.
     - returns: The formatted string ready for output.
     */
    func string(for log: TLog) -> String
}

extension TLogToStringFormatterProtocol {
    public func format(_ log: TLog) -> Any {
        return string(for: log)
    }
}

/**
 The Tambo default formatter.
 This formatter can be used as follows:
    1. Set the format string to feet your needs; or not if the default behavior
        is good enough.
    2. Set the dateFormatter to feet your needs; or not if the default behavior
        is good enough.
    3. Set the formatter to the `Stream` you'd like to use. This can be also
        achieved by selecting the `.default`
 [TLogFormatterOption](x-source-tag://T.TLogFormatterOption) if you're using
 one of the `Streams` provided by Tambo.
 - Tag: T.TLogDefaultStringFormatter
 */
public class TLogDefaultStringFormatter: TLogToStringFormatterProtocol {

    /**
     The formate rule this formatter will follow to present the log information.
     - note: The keys are documented in the
     [SLLogFormatKey](xc-source-tag://T.SLLogFormatKey)
     */
    public var format = """
        [D] [L] T S F.f:# - M
        I
        """

    /**
     The date formatter to be used to produce the string value.
     - note: The default one will format the date using `"HH:mm:ss.SSS"`
     */
    public var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss.SSS"
        return df
    }()

    /**
     Designated initializer.
     */
    public init() {
        // NOTE: this is defined because otherwise it would be internal.
    }

    /**
     Produces a string from a [TLog](x-source-tag://T.TLog) object.
     - parameter log: The TLog object we want to convert into a string.
     - seealso: [TLogToStringFormatterProtocol](x-source-tag://T.TLogToStringFormatterProtocol)
     */
    func string(for log: TLog) -> String  {
        var outputString = ""

        format.forEach { ch in
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
    case userInfo = "I"
}
