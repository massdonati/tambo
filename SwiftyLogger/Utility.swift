//
//  Utility.swift
//  SwiftyLogger
//
//  Created by Massimo Donati on 7/24/18.
//

import Foundation
import Dispatch

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
            return "main_thread"
        } else {
            let threadName = Thread.current.name
            if let threadName = threadName, !threadName.isEmpty {
                return threadName
            } else {
                var threadID: UInt64 = 0
                pthread_threadid_np(nil, &threadID)
                return "bg_thread_\(threadID)"
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
            if (JSONSerialization.isValidJSONObject(value) == false
                && (value is Encodable) == false) {
                self[key] = String(describing: value) as? Value
            }
        }
    }
}
