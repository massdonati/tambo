//
//  Tambo + combine.swift
//  
//
//  Created by Massimo Donati on 12/2/22.
//

import Foundation
import Combine

extension Tambo {

    public func formattedLogsPublisher<Output, Formatter>(_ formatter: Formatter) -> AnyPublisher<Output, Never> where Formatter: TamboLogFormatter, Output == Formatter.FormattedType {
        return formattedLogsPublisher(formatter.format(_:))
    }

    public func formattedLogsPublisher<Output>(_ closure: @escaping (Event) -> Output) -> AnyPublisher<Output, Never>{
        return logsPublisher
            .map(closure)
            .eraseToAnyPublisher()
    }

    public func stringFormattedLogsPublisher(_ stringFormat: String? = nil) -> AnyPublisher<String, Never> {
        return formattedLogsPublisher(TamboStringFormatter(with: stringFormat))
    }

    public var unformattedLogsPublisher: AnyPublisher<Event, Never> { logsPublisher }
}
