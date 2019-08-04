//
//  TLog+Equatable.swift
//  Tambo iOS
//
//  Created by Massimo Donati on 8/3/19.
//

import Foundation

extension TLog: Equatable {
    public static func == (lhs: TLog, rhs: TLog) -> Bool {
        return lhs.loggerID == rhs.loggerID
        && lhs.level == rhs.level
        && lhs.date == rhs.date
        && String(describing: lhs.message) == String(describing: rhs.message)
        && lhs.threadName == rhs.threadName
        && lhs.functionName == rhs.functionName
        && lhs.fileName == rhs.fileName
        && lhs.filePath == rhs.filePath
        && lhs.lineNumber == rhs.lineNumber
        && lhs.contextJSONString == rhs.contextJSONString
    }
}
