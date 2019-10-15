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
    public let filters: TThreadProtector<[TFilterClosure]>
    public var isAsync: Bool = false
    public var identifier: String
    public var outputLevel: TLogLevel
    public var queue = DispatchQueue.global()
    public var logFormatter = TLogStringFormatter()
    private var printMode: TConsolePrintMode = .print

    /**
     Designated initializer
     - parameter identifier: a string identifier for the stream used to name the queue
        it'll dispatch the processing of the log structs if `isAsync` is `true`.
     - parameter printMode: tells the stream which primitive tu use to print the formatted
        log message to the console.
     - parameter dispatchQueue: the dispatch queue used to defer the processing of the log
        structs if `isAsync` is `true`.
     */
    public init(identifier: String,
                printMode: TConsolePrintMode,
                dispatchQueue: DispatchQueue? = nil) {
        self.printMode = printMode
        self.identifier = identifier
        outputLevel = .verbose
        filters = TThreadProtector<[TFilterClosure]>([])
        queue = streamQueue(target: dispatchQueue)
    }
    
    public func output(log: TLog, formattedLog: String) {
        switch printMode {
        case .print:
            print(formattedLog)
        case .nsLog:
            NSLog("%@", formattedLog)
        }
    }
}
