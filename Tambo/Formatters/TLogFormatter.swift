//
//  TLogDefaultFormatter.swift
//  Tambo
//
//  Created by Massimo Donati on 7/23/18.
//

import Foundation

/**
 These are the possible options to select a `LogFormatter`.
 - Tag: T.TLogFormatterOption
 */
public enum TLogFormatterOption {
    /**
     [TLogDefaultStringFormatter](x-source-tag://T.TLogDefaultStringFormatter)
     will be used.
     */
    case defaultString

    case defaultJSON

    /**
     A custom user-defined formatter.
     *USE*:
     ```
     let myFormatterOpt: TLogFormatterOption = .custom(MyFormatter())
     ```
     */
    case custom(PATWrapper)
}

/**
 Defines a public interface that every user-defined formatter needs to
 conform to.
 - Tag: T.TLogFormatterProtocol
 */
public protocol TLogFormatterProtocol {
    associatedtype FormattedType
    /**
     Formats a [TLog](x-source-tag://T.TLog) object into anything.
     - parameter log: The TLog object that needs formatting.
     - returns: Anything the Tlog object was converted to.
     - note: The return type is specifically left generic for flexibility
        purposes.
     - note: This function will be invoked right befor outputting the log
        from watever stream this message was invoked.
     */
    func format(_ log: TLog) -> FormattedType

    /// The date formatter used to convert the log's date into a string.
    var dateFormatter: DateFormatter {get set}
}

public final class PATWrapper {
    private let obj: Any

    init<T: TLogFormatterProtocol>(obj: T) {
        self.obj = obj
    }

    func wrappedObj<T: TLogFormatterProtocol>() -> T {
        return obj as! T
    }
}
