//
//  TStreamFilterable.swift
//  Tambo
//
//  Created by Massimo Donati on 8/15/18.
//

import Foundation

/**
 A closure that will determine if a `TLog` should be filtered or not.
 - parameter log: The TLog instance to be evaluated.
 - returns: true if the `TLog` should be discarded, false otherwise.
 */
public typealias TFilterClosure = (_ log: TLog) -> Bool

/**
 Defines the behavior able to filter `TLog` instances.
 */
public protocol TLogFilterer: class {
    /**
     Array of filters that will be used to check if a `TLog` instance
     should be filtered or not.
     */
    var filters: TThreadProtector<[TFilterClosure]> {get}

    /**
     - returns: true wether a TLog should be discarded, false otherwise.
     - parameter log: T `TLog` instance to be evaluated.
     - note: The default implementation will evaluate all the filters
        and reduce the result of each filter into a final decision.
     */
    func should(filter log: TLog) -> Bool

    /**
     Helper method to to add a filter.
     - parameter f: the filter to add to the list.
     */
    func add(filter f: @escaping TFilterClosure)

    /// Removes all the filters currently in the list.
    func removeFilters()
}

extension TLogFilterer {
    public func should(filter log: TLog) -> Bool {
        return filters.read { (underlyingFilters) -> Bool in
            if underlyingFilters.isEmpty { return false }

            let result = underlyingFilters
                .map { $0(log) }
                .reduce(false) { $0 || $1 }

            return result
        }
    }

    public func add(filter f: @escaping TFilterClosure) {
        filters.write { filters in
            filters.append(f)
        }
    }

    public func removeFilters() {
        filters.write { filters in
            filters.removeAll()
        }
    }
}
