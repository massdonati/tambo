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

enum JSON {
    static func validObject(from: Any) -> Any {
        var validValue: Any = String(describing: from)

        if let ancodedData = (from as? Encodable)?.toJSONData() {

            do {
                validValue = try JSONSerialization.jsonObject(with: ancodedData, options: .allowFragments)
            } catch {
                TamboLogger.default.error("Tambo JSON conversion faild, please file an issue in the github repo with more info as possible", context: ["error": .string("\(error)")])
            }
        }

        return validValue
    }
}

extension Dictionary where Key == String, Value == LogContextValue {

    /**
    Converts any values of self which is not a valid json object to a string discribing
     that value.
    - note: the values which are already valid json objects will not be modified.
    */
    func prettify() -> String? {
        guard isEmpty == false else { return nil }
        return """
        {
            \(`lazy`
                .sorted(by: { $0.key < $1.key })
                .map { "\($0) = \($1)" }
                .joined(separator: "\n")
        )
        }
        """
    }
}

extension Encodable {
    /**
     Converts, if possible, the current encodable object into data using `JesonEncoder`
     - returns: a json representation `Data` object of this object. nil if the encoding
        faild
     */
    func toJSONData() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
