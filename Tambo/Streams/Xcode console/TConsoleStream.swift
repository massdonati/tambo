//
//  TConsoleStream.swift
//  Tambo
//
//  Created by Massimo Donati on 7/26/18.
//

import Foundation

/**
 Defines whether the console stream should use the print function
 or the NSLog one
 */
public enum TConsolePrintMode {
    case print, nsLog
}

/// The Xcode console stream. It will output the logs to the Xcode console.
public final class TConsoleStream: TBaseQueuedStream {
    private let printMode: TConsolePrintMode

    public init(identifier: String,
                formatterOption: TLogFormatterOption = .defaultString,
                printMode: TConsolePrintMode = .print) {
        self.printMode = printMode
        super.init(identifier: identifier, formatterOption: formatterOption)
    }

    /**
     This stream will output the logs to the console either as a String.
     - note: If `JSONSerialization.isValidJSONObject(formattedLog)` a
        prettyPrinted string version will be printed to the console instead.
     - seealso: [TStreamProtocol](x-source-tag://T.TStreamProtocol)
     */
    override public func output(log: TLog, formattedLog: Any) {
        if let textMessage = formattedLog as? String {
            print(message: textMessage)
        }

        guard JSONSerialization.isValidJSONObject(formattedLog) else {
            print(message: String(describing: formattedLog))
            return
        }

        if let jsonData = try? JSONSerialization.data(withJSONObject: formattedLog,
                                                      options: .prettyPrinted) {
            print(message: String(data: jsonData, encoding: .utf8) ?? "")
        } else {
            // just for safety.
            print(message: String(describing: formattedLog))
        }
    }

    private func print(message: String) {
        switch printMode {
        case .print:
            Swift.print(message)
        case .nsLog:
            NSLog("%@", message)
        }
    }
}
