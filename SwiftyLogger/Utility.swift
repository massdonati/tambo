//
//  Utility.swift
//  SwiftyLogger
//
//  Created by Massimo Donati on 7/24/18.
//

import Foundation

struct Utility {
    /// returns the current thread name
    static func threadName() -> String {

        #if os(Linux)
        // on 9/30/2016 not yet implemented in server-side Swift:
        // > import Foundation
        // > Thread.isMainThread
        return ""
        #else
        if Thread.isMainThread {
            return "[main_thread]"
        } else {
            let threadName = Thread.current.name
            if let threadName = threadName, !threadName.isEmpty {
                return threadName
            } else {
                return String(format: "[%p]", Thread.current)
            }
        }
        #endif
    }

    static func filename(from path: String) -> String? {
        guard var url = URL(string: path) else { return nil }

        url.deletePathExtension()
        return url.pathComponents.last
    }
}

extension Dictionary where Key : StringProtocol, Value : Any {
    mutating func jsonify() {
        keys.forEach { key in
            guard let value = self[key] else { return }
            if !JSONSerialization.isValidJSONObject(value) {
                self[key] = String(describing: value) as? Value
            }
        }
    }
}
