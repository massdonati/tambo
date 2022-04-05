//
//  File.swift
//  
//
//  Created by Massimo Donati on 4/4/22.
//

import Foundation

public extension TamboLogger {

    @inlinable
    func error(
        _ msgClosure: @autoclosure @escaping () -> Any,
        condition: Bool? = nil,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: [String: LogContextValue]? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            condition: condition,
            level: .error,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }

    @inlinable
    func warning(
        _ msgClosure: @autoclosure @escaping () -> Any,
        condition: Bool = true,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: [String: LogContextValue]? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            condition: condition,
            level: .warning,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }

    @inlinable
    func info(
        _ msgClosure: @autoclosure @escaping () -> Any,
        condition: Bool? = nil,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: [String: LogContextValue]? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            condition: condition,
            level: .info,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }

    @inlinable
    func debug(
        _ msgClosure: @autoclosure @escaping () -> Any,
        condition: Bool? = nil,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: [String: LogContextValue]? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            condition: condition,
            level: .debug,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }

    @inlinable
    func trace(
        _ msgClosure: @autoclosure @escaping () -> Any,
        condition: Bool? = nil,
        functionName: StaticString = #function,
        filePath: StaticString = #file,
        lineNumber: Int = #line,
        context: [String: LogContextValue]? = nil) {

        propagateLog(
            msgClosure: msgClosure,
            condition: condition,
            level: .trace,
            functionName: String(describing: functionName),
            filePath: String(describing: filePath),
            lineNumber: lineNumber,
            context: context
        )
    }
}
