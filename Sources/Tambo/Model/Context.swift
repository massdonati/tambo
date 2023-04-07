//
//  Context.swift
//  
//
//  Created by Massimo Donati on 4/7/23.
//

import Foundation

public typealias Context = [String: Any]

extension Context {
    public var stringFormatted: String? {
        prettify()
    }

    /**
    Converts any values of self which is not a valid json object to a string discribing
     that value.
    - note: the values which are already valid json objects will not be modified.
    */
    func prettify() -> String? {
        guard isEmpty == false else { return nil }
        return """
        {
            \(`lazy`
                .map { "\($0) = \($1)" }
                .joined(separator: "\n")
        )
        }
        """
    }
}
