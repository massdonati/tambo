//
//  Log+Equatable.swift
//  Tambo iOS
//
//  Created by Massimo Donati on 8/3/19.
//

import Foundation

extension Log: Equatable {
    public static func == (lhs: Log, rhs: Log) -> Bool {
        return lhs.id == rhs.id
    }
}
