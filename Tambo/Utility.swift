//
//  Utility.swift
//  Tambo
//
//  Created by Massimo Donati on 7/24/18.
//

import Foundation
import Dispatch

struct Utility {
    /**
     returns the current thread name
     */
    static func threadName() -> String {
        if Thread.isMainThread {
            return "main_thread"
        }

        let threadName = Thread.current.name
        if let threadName = threadName, !threadName.isEmpty {
            return threadName
        }

        return String(describing: Thread.current)
    }

    static func filename(from path: String, chopExtension: Bool = true) -> String? {
        guard var url = URL(string: path) else { return nil }
        if chopExtension {
            url.deletePathExtension()
        }
        return url.pathComponents.last
    }
}

extension Dictionary where Key : StringProtocol, Value : Any {
    mutating func jsonify() {
        keys.forEach { key in
            guard let value = self[key] else { return }
            if (JSONSerialization.isValidJSONObject(value) == false
                && (value is Encodable) == false) {
                self[key] = String(describing: value) as? Value
            }
        }
    }
}

public class TThreadProtector<T> {
    private var resource: T
    private let recLock = NSRecursiveLock()
    init(_ resource: T) {
        recLock.name = "TThreadProtector.recLock"
        self.resource = resource
    }

    func read<U>(_ closure: (T) -> U) -> U {
        recLock.lock()
        defer {
            recLock.unlock()
        }
        return closure(resource)
    }

    func write<U>(_ closure: (inout T) -> U) -> U {
        recLock.lock()
        defer {
            recLock.unlock()
        }
        return closure(&resource)
    }
}
