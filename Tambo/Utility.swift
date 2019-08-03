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

    /**
     - returns: The fileName of a file from its complete path.
     - parameter path: the file string URL.
     - parameter chopExtension: wether we want to remove the file extension.
     - note: This method will return nil if the path string is not a valid URL.
     */
    static func filename(from path: String, chopExtension: Bool = true) -> String? {
        guard path.isEmpty == false else { return nil }
        var url = URL(fileURLWithPath: path)
        if chopExtension {
            url.deletePathExtension()
        }
        return url.pathComponents.last
    }
}

extension Dictionary where Key: StringProtocol, Value: Any {

    /**
     Converts any values of self which is not encodable or not a valid json object to a
     string discribing that value.
     - note: the values which are already encodable or valid json objects will not be
        modified.
     */
    mutating func makeJsonEncodable() {
        forEach { (key, value) in
            guard (JSONSerialization.isValidJSONObject(value) == false
                && (value is Encodable) == false) else { return }

            self[key] = String(describing: value) as? Value
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
