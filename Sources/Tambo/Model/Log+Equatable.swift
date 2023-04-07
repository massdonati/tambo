//
//  Log+Equatable.swift
//  Tambo iOS
//
//  Created by Massimo Donati on 8/3/19.
//

import Foundation

extension Event: Equatable {
    public static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}
