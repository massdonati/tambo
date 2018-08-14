//
//  TLogDefaultFormatter.swift
//  Tambo
//
//  Created by Massimo Donati on 7/23/18.
//

import Foundation

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
}
