//
//  Tambo + Logging.swift
//  
//
//  Created by Massimo Donati on 12/2/22.
//

import Foundation

extension Tambo {
    // MARK: - logging methods

    @inlinable
    public func critical(
        _ msgClosure: @autoclosure @escaping () -> String,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: Context? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            level: .critical,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }

    @inlinable
    public func error(
        _ msgClosure: @autoclosure @escaping () -> String,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: Context? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            level: .error,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }

    @inlinable
    public func warning(
        _ msgClosure: @autoclosure @escaping () -> String,
        condition: Bool = true,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: Context? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            level: .warning,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }

    @inlinable
    public func info(
        _ msgClosure: @autoclosure @escaping () -> String,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: Context? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            level: .info,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }

    @inlinable
    public func debug(
        _ msgClosure: @autoclosure @escaping () -> String,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: Context? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            level: .debug,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }

    @inlinable
    public func trace(
        _ msgClosure: @autoclosure @escaping () -> String,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: Context? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            level: .trace,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }
}
