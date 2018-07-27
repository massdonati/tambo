//
//  TConsoleStream.swift
//  Tambo
//
//  Created by Massimo Donati on 7/26/18.
//

import Foundation

public enum TConsolePrintMode {
    case print, nsLog
}

public final class TConsoleStream: TBaseStream {
    let printMode: TConsolePrintMode

    public init(identifier: String,
                formatterOption: TLogFormatterOption = .default,
                printMode: TConsolePrintMode = .print) {
        self.printMode = printMode
        super.init(identifier: identifier, formatterOption: formatterOption)
    }

    override public func output(logDetails: TLog, message: String) {
        switch printMode {
        case .print:
            print(message)
        case .nsLog:
            NSLog("%@", message)
        }
    }
}
