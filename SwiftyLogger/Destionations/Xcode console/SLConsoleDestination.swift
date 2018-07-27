//
//  SLConsoleDestination.swift
//  SwiftyLogger
//
//  Created by Massimo Donati on 7/26/18.
//

import Foundation

public enum SLConsolePrintMode {
    case print, nsLog
}

public final class SLConsoleDestination: SLBaseDestination {
    let printMode: SLConsolePrintMode
    public init(identifier: String, formatterOption: SLLogFormatterOption, printMode: SLConsolePrintMode) {
        self.printMode = printMode
        super.init(identifier: identifier, formatterOption: formatterOption)
    }
    override public func output(logDetails: SLLog, message: String) {
        switch printMode {
        case .print:
            print(message)
        case .nsLog:
            NSLog("%@", message)
        }

    }
}
