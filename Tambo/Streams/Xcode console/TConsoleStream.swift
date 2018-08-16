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
public final class TConsoleStream: TStreamFormattable {
    public var filters: [FilterProtocol] = []
    public var isAsync: Bool = true
    public var identifier: String
    public var outputLevel: TLogLevel
    public var queue = DispatchQueue(label: "")
    public var logFormatter = TLogStringFormatter()
    private var printMode: TConsolePrintMode = .print

    public init(identifier: String,
                printMode: TConsolePrintMode) {
        self.printMode = printMode
        self.identifier = identifier
        outputLevel = .verbose
        self.queue = streamQueue()
    }
    
    public func output(log: TLog, formattedLog: String) {
        print(message: formattedLog)
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
