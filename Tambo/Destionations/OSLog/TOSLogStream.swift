//
//  SLOSLogDestination.swift
//  Tambo
//
//  Created by Massimo Donati on 7/23/18.
//

import Foundation
import os

public final class TOSLogStream: TBaseStream {
    let log: OSLog
    let mapping: TOSLogTypeMapper
    public init(
        identifier: String,
        formatterOption: TLogFormatterOption = .default,
        subsystem: String,
        category: String,
        mapping: TOSLogTypeMapper = .default) {

        log = OSLog(subsystem: subsystem, category: category)
        self.mapping = mapping
        super.init(identifier: identifier, formatterOption: formatterOption)
    }

    override public func output(logDetails: TLog, message: String) {
        let type = mapping.osLogType(for: logDetails.level)
        os_log("%{public}@", log: log, type: type, message)
    }
}
