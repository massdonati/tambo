//
//  File.swift
//  
//
//  Created by Massimo Donati on 4/4/22.
//

import Foundation
import Combine


extension Publisher where Output == String, Failure == Never {
    func logToConsole() -> AnyPublisher<Void, Never> {
            flatMap { string -> AnyPublisher<Void, Never> in
                Swift.print(string)
                return Just<Void>(()).eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }
}
