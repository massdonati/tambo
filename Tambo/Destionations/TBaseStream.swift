//
//  TBaseStream.swift
//  Tambo
//
//  Created by Massimo Donati on 7/23/18.
//

import Foundation

/// A base class destination that doesn't actually output the log anywhere and is intended to be subclassed
public class TBaseStream: TStreamProtocol {

    /// Identifier for the destination (should be unique)
    open var identifier: String

    /// Log level for this destination
    open var outputLevel: TLogLevel = .debug

    /// Flag whether or not we've logged the app details to this destination
    open var haveLoggedAppDetails: Bool = false

    public var logFormatter: TLogFormatterProtocol
    /// Array of log filters to apply to messages before they're output
//    open var filters: [FilterProtocol]? = nil

    /// Option: whether or not to output the log identifier
    open var showLogIdentifier: Bool = false

    /// Option: whether or not to output the function name that generated the log
    open var showFunctionName: Bool = true

    /// Option: whether or not to output the thread's name the log was created on
    open var showThreadName: Bool = false

    /// Option: whether or not to output the fileName that generated the log
    open var showFileName: Bool = true

    /// Option: whether or not to output the line number where the log was generated
    open var showLineNumber: Bool = true

    /// Option: whether or not to output the log level of the log
    open var showLevel: Bool = true

    /// Option: whether or not to output the date the log was created
    open var showDate: Bool = true

    // MARK: - Life Cycle
    public init(identifier: String = "", formatterOption: TLogFormatterOption = .default) {
        self.identifier = identifier

        switch formatterOption {
        case .default:
            logFormatter = TLogDefaultFormatter()
        case .custom(let formatter):
            logFormatter = formatter
        }
    }

    // MARK: - Methods to Process Log Details
    /**
     Process the log details.
     - parameter logDetails: structure with all of the details for the log
        to process.
     */
    open func process(log: TLog) {
        let formattedMessage = logFormatter.string(for: log)

        output(logDetails: log, message: formattedMessage)
    }

    // MARK: - Methods that must be overridden in subclasses
    /**
     Output the log to the destination i.e. file, backend, db etc.
     - parameter logDetails: The log details.
     - parameter message: Formatted/processed message ready for output.
    */
    public func output(logDetails: TLog, message: String) {
        precondition(false,
                     "Every subclass needs to override this method.")
    }
}
