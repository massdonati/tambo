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
    static func threadType() -> ThreadType {
        if Thread.isMainThread {
            return .main
        }

        let threadName = Thread.current.name
        if let threadName = threadName, !threadName.isEmpty {
            return .background(threadName)
        }

        return .background(String(describing: Thread.current))
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
