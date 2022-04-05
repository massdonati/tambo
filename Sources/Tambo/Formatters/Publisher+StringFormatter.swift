//
//  File.swift
//  
//
//  Created by Massimo Donati on 4/4/22.
//

import Foundation
import Combine


public extension Publisher where Output == Log, Failure == Never {

    func formatWithDefaultStringFormatter(_ formatter: TamboStringFormatter = .init() ) -> AnyPublisher<String, Never> {
        return formatWith(formatter)
    }
}
