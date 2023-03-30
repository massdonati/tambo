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
    case array([LogContextValue])
    case dictionary([String: LogContextValue])
    case error(Error)

    public var value: Any {
        switch self {
        case .string(let string):
            return string
        case .customStringConvertible(let customStringConvertible):
            return customStringConvertible
        case .array(let array):
            return array.lazy.map { $0.value }
        case .dictionary(let dictionary):
            return dictionary.mapValues { $0.value }
        case .error(let error):
            return String(describing: error)
        }
    }
}
