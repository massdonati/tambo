//
//  SLOSLogStream.swift
//  Tambo
//
//  Created by Massimo Donati on 7/23/18.
//

import Foundation
import os

/**
 The Apple Unified log stream. It will output the logs to the macOS Console app.
 - seealso: [Apple logging](https://developer.apple.com/documentation/os/logging)
 - important: everything logged by this stream will use the "{public}@" format.
 */
public final class TOSLogStream: TBaseQueuedStream {
    let osLog: OSLog
    let mapping: TOSLogTypeMapper

    /**
     Designated initializer.
     - parameter identifier: A unique identifier that will identify the stream.
     - parameter formatterOption: Which log formatter we want to use for this
        stream.
     - parameter queue: The queue all the logging operations will be queued on.
        This doesn't need to be a serial one because the stream will use this
        as a target for its own serial queue.
     - parameter subsystem: The particular subsystem this stream will logs
        events of. For example, com.your_company.your_subsystem_name.
        seealso [Apple docs](https://developer.apple.com/documentation/os/oslog/2320726-init)
     - parameter category: A category within the specified subsystem.
        seealso [Apple docs](https://developer.apple.com/documentation/os/oslog/2320726-init)
     */
    public init(
        identifier: String,
        queue: DispatchQueue? = nil,
        subsystem: String,
        category: String,
        mapping: TOSLogTypeMapper = .default) {

        osLog = OSLog(subsystem: subsystem, category: category)
        self.mapping = mapping
        super.init(identifier: identifier,
                   formatterOption: .defaultString,
                   queue: queue)
    }

    override public func process(_ log: TLog) {
        let processClosure = {
            let formattedLog = self.logFormatter.format(log)
            self.output(log: log, formattedLog: formattedLog)
        }
        if isAsync {
            queue.async(execute: processClosure)
        } else {
            queue.sync(execute: processClosure)
        }
    }

    override public func output(log: TLog, formattedLog: Any) {
        precondition(formattedLog is String, """
            Override TOSLogStream.output method if you want to use a type \
            different then a String.
            """)

        let type = mapping.osLogType(for: log.level)
        os_log("%{public}@", log: osLog, type: type, String(describing: stringMessage))
    }
}
