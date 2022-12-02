//
//  File.swift
//  
//
//  Created by Massimo Donati on 4/4/22.
//

import Foundation
import Combine

extension Publisher where Output == String, Failure == Never {
    public func printLogs() -> AnyCancellable {
        sink { string in
            Swift.print(string)
        }
    }
}
