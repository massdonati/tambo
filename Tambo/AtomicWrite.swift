//
//  AtomicWrite.swift
//  Tambo
//
//  Created by Massimo Donati on 10/29/19.
//

import Foundation

@propertyWrapper
public struct AtomicWrite<Value> {

    let lock = NSRecursiveLock()
    var value: Value

    public init(wrappedValue: Value) {
        lock.name = "com.tambo.atomicWrite"
        self.value = wrappedValue
    }

    public var wrappedValue: Value {
        get {
            lock.lock()
            defer {
                lock.unlock()
            }
            return value
        }
        set {
            lock.lock()
            value = newValue
            lock.unlock()
        }
    }

    public mutating func mutate(_ mutation: (inout Value) throws -> Void) rethrows {
        lock.lock()
        defer {
            lock.unlock()
        }
        try mutation(&value)
    }
}
