//
//  OSLogStream.swift
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
public final class OSLogStream: StreamFormattable {

    static let osLogFormat = """
        S F:# f - M
        C
        """

    public var filters: AtomicWrite<[FilterClosure]> = AtomicWrite(wrappedValue: [])

    public var isAsync: Bool = true
    public var identifier: String
    public var outputLevel: LogLevel = .trace
    public var queue = DispatchQueue.global()
    public var logFormatter = LogStringFormatter(with: osLogFormat)
    let osLog: OSLog
    let mapping: OSLogTypeMapper
    public var metadata: [String : Any]?

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
        mapping: OSLogTypeMapper = .default) {

        self.identifier = identifier
        osLog = OSLog(subsystem: subsystem, category: category)
        self.mapping = mapping
        self.queue = streamQueue(target: queue)
    }
    
    public func output(log: Log, formattedLog: String) {

        let type = mapping.osLogType(for: log.level)
        os_log("%{public}@", log: osLog, type: type, formattedLog)
    }
}
