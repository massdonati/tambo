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
    func should(filterOut log: TLog) -> Bool

    /**
     Helper method to add a filter.
     - parameter f: the filter to add to the list.
     */
    func addFilterOutClosure(_ f: @escaping TFilterClosure)

    /// Removes all the filters currently in the list.
    func removeFilters()
}

extension TLogFilterer {
    public func should(filterOut log: TLog) -> Bool {
        return filters.read { (underlyingFilters) -> Bool in
            if underlyingFilters.isEmpty { return false }

            let result = underlyingFilters
                .map { $0(log) } // [true, false, false, ...]
                .filter { $0 == true } // [true, true, true, ...] || []
                // if the filtered array is not empty the log needs to be discarded
                .isEmpty == false

            return result
        }
    }

    public func addFilterOutClosure(_ f: @escaping TFilterClosure) {
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
