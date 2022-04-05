//
//  File.swift
//  
//
//  Created by Massimo Donati on 4/4/22.
//

import Foundation
import Combine

public extension Publisher where Output == Log, Failure == Never {
    func formatWith<T>(_ formatter: T) -> AnyPublisher<T.FormattedType, Never> where T: TamboLogFormatter {
        map { formatter.format($0) }.eraseToAnyPublisher()
    }
}
