//
//  TamboStringFormatter.swift
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
 - Tag: T.TamboStringFormatter
 */
struct TamboStringFormatter: TamboLogFormatter {
    static let defaultFormat = """
        [D] [L] T S F:# f - M
        C
        """
    /**
     The formate rule this formatter will follow to present the log information.
     - note: The keys are documented in the
     [LogFormatKey](xc-source-tag://T.LogFormatKey)
     */
    let logFormat: String

    /**
     The date formatter to be used to produce the string value.
     - note: The default one will format the date using `"HH:mm:ss.SSS"`
     */
    public var dateFormatter: DateFormatter

    /// Designated initializer.
    init(with format: String? = nil) {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.SSS"
        logFormat = format ?? Self.defaultFormat
    }

    /**
     Produces a string from a [Log](x-source-tag://T.Log) object.
     - parameter log: The Log object we want to convert into a string.
     - seealso: [LogToStringFormatterProtocol](x-source-tag://T.LogToStringFormatterProtocol)
     */
    public func format(_ log: Log) -> String  {
        var outputString = ""

        logFormat.forEach { ch in
            switch ch {
            case LogFormatKey.date.rawValue:
                outputString += dateFormatter.string(from: log.date)
            case LogFormatKey.logger.rawValue:
                outputString += log.loggerID
            case LogFormatKey.level.rawValue:
                outputString += log.level.name
            case LogFormatKey.levelSymbol.rawValue:
                outputString += log.level.symbol
            case LogFormatKey.message.rawValue:
                outputString += String(describing: log.message())
            case LogFormatKey.thread.rawValue:
                switch log.threadType {
                case .main:
                    outputString += "main-thread"
                case .background(let description):
                    outputString += description
                }
            case LogFormatKey.function.rawValue:
                outputString += log.functionName
            case LogFormatKey.file.rawValue:
                outputString += log.fileName
            case LogFormatKey.line.rawValue:
                outputString += String(describing: log.lineNumber)
            case LogFormatKey.context.rawValue:
                if let context = log.context, let contextString = context.prettify() {
                    outputString += contextString
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
enum LogFormatKey: Character {

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
     The thread name the [Log](x-source-tag://T.Log) was originate from.
     The possible values are:
        1. "main_thread"
        2. the thread name
        3. the string descritpion of the thread
     */
    case thread = "T"

    /// The function name the [TLog](x-source-tag://T.TLog) was originated from.
    case function = "f"

    /**
     The file name the [Log](x-source-tag://T.Log) was originated
     from i.e. `MyFile`
     - note: this doesn't include the file extension.
     */
    case file = "F"

    /// The line number the [TLog](x-source-tag://T.TLog) was originated from.
    case line = "#"

    /// Any additional metadata useful to give more context to the logs.
    case context = "C"
}


