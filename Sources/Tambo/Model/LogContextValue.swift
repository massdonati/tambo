//
//  LogContextValue.swift
//  
//
//  Created by Massimo Donati on 4/4/22.
//

import Foundation

public enum LogContextValue {
    case string(String)
    case csc(CustomStringConvertible)
    case dict([String: LogContextValue])
    case error(Error)

    public var value: Any {
        switch self {
        case .string(let string):
            return string
        case .csc(let convertible):
            return convertible.description
        case .dict(let dictionary):
            return dictionary.mapValues { $0.value }
        case .error(let error):
            return String(describing: error)
        }
    }
}
