//
//  Tambo + Functional.swift
//  
//
//  Created by Massimo Donati on 12/2/22.
//

import Foundation
import Combine

extension Tambo {
    func allowLevels(_ levels: [LogLevel]) -> Self {
        allowedLevels = levels
        return self
    }

    func formatLog<Output, Formatter>(_ formatter: Formatter) -> AnyPublisher<Output, Never> where Formatter: TamboLogFormatter, Output == Formatter.FormattedType {
        return formatLog(formatter.format(_:))
    }

    func formatLog<Output>(_ closure: @escaping (Log) -> Output) -> AnyPublisher<Output, Never>{
        return logsPublisher
            .map(closure)
            .eraseToAnyPublisher()
    }

    func formatToString(_ stringFormat: String? = nil) -> AnyPublisher<String, Never> {
        return formatLog(TamboStringFormatter(with: stringFormat))
    }
}
