//
//  File.swift
//  
//
//  Created by Massimo Donati on 4/4/22.
//

import Foundation
import Combine

private var cancellables: [AnyCancellable] = []
extension Publisher where Output == String, Failure == Never {
    public func logToConsole() {
        sink { string in
            Swift.print(string)
        }.store(in: &cancellables)
    }
}
