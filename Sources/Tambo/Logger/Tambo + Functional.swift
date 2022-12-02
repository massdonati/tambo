//
//  Tambo + Functional.swift
//  
//
//  Created by Massimo Donati on 12/2/22.
//

import Foundation
import Combine

extension Tambo {
    public func allowingLevels(_ levels: LogLevel...) -> Self {
        return allowingLevels(levels)
    }

    public func allowingLevels(_ levels: [LogLevel]) -> Self {
        allowedLevels = levels
        return self
    }

    public func formattedLogsPublisher<Output, Formatter>(_ formatter: Formatter) -> AnyPublisher<Output, Never> where Formatter: TamboLogFormatter, Output == Formatter.FormattedType {
        return formattedLogsPublisher(formatter.format(_:))
    }

    public func formattedLogsPublisher<Output>(_ closure: @escaping (Log) -> Output) -> AnyPublisher<Output, Never>{
        return logsPublisher
            .map(closure)
            .eraseToAnyPublisher()
    }

    public func formattedLogsToStringPublisher(_ stringFormat: String? = nil) -> AnyPublisher<String, Never> {
        return formattedLogsPublisher(TamboStringFormatter(with: stringFormat))
    }
}
