//
//  File.swift
//  
//
//  Created by Massimo Donati on 4/4/22.
//

import Foundation
import Combine


public extension Publisher where Output == Log, Failure == Never {

    func formatToString(_ formatter: TamboStringFormatter = .init() ) -> AnyPublisher<String, Never> {
        return format(with: formatter)
    }
}
