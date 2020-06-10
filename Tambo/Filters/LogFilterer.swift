//
//  LogFilterer.swift
//  Tambo
//
//  Created by Massimo Donati on 8/15/18.
//

import Foundation

/**
 A closure that will determine if a `Log` should be filtered or not.
 - parameter log: The Log instance to be evaluated.
 - returns: true if the `Log` should be discarded, false otherwise.
 */
public typealias FilterClosure = (_ log: Log) -> Bool

/**
 Defines the behavior able to filter `Log` instances.
 */
public protocol LogFilterer: AnyObject {
    /**
     Array of filters that will be used to check if a `Log` instance
     should be filtered or not.
     */
    var filters: AtomicWrite<[FilterClosure]> {get set}

    /**
     - returns: true wether a Log should be discarded, false otherwise.
     - parameter log: T `Log` instance to be evaluated.
     - note: The default implementation will evaluate all the filters
        and reduce the result of each filter into a final decision.
     */
    func should(filterOut log: Log) -> Bool

    /**
     Helper method to add a filter.
     - parameter f: the filter to add to the list.
     */
    func addFilterOutClosure(_ f: @escaping FilterClosure)

    /// Removes all the filters currently in the list.
    func removeFilters()
}

extension LogFilterer {
    public func should(filterOut log: Log) -> Bool {
        if filters.value.isEmpty { return false }

        let result = filters.value
            .map { $0(log) } // [true, false, false, ...]
            .filter { $0 == true } // [true, true, true, ...] || []
            // if the filtered array is not empty the log needs to be discarded
            .isEmpty == false

        return result
    }

    public func addFilterOutClosure(_ f: @escaping FilterClosure) {
        filters.mutate { $0.append(f) }
    }

    public func removeFilters() {
        filters.mutate { $0.removeAll() }
    }
}
