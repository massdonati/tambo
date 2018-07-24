//
//  SLOSLogDestination.swift
//  SwiftyLogger
//
//  Created by Massimo Donati on 7/23/18.
//

import Foundation
import os

public final class SLOSLogDestination: SLBaseDestination {
    let log: OSLog
    let mapping: SLOSLogTypeMapper
    public init(
        identifier: String,
        formatterOption: SLLogFormatterOption = .default,
        subsystem: String,
        category: String,
        mapping: SLOSLogTypeMapper = .default) {

        log = OSLog(subsystem: subsystem, category: category)
        self.mapping = mapping
        super.init(identifier: identifier, formatterOption: formatterOption)
    }

    public override func output(logDetails: SLLog, message: String) {
        let type = mapping.osLogType(for: logDetails.level)
        os_log("%{public}@", log: log, type: type, message)
    }
}
