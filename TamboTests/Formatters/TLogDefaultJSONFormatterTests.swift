//
//  TLogDefaultJSONFormatterTests.swift
//  Tambo
//
//  Created by Massimo Donati on 8/5/18.
//

import XCTest
@testable import Tambo

class TLogDefaultJSONFormatterTests: XCTestCase {
    var formatter: TLogDefaultJSONFormatter!
    override func setUp() {
        formatter = TLogDefaultJSONFormatter()
    }

    override func tearDown() {
        formatter = nil
    }

    func testDefaultDateFormatterFormat() {
        XCTAssertEqual(formatter.dateFormatter.dateFormat,
                       "yyyy-MM-dd HH:mm:ss Z")
    }

    func testLogToJSONWithoutUserInfo() {
        let loggerId = "logger_id"
        let level = TLogLevel.debug.name
        let expectedDate = Date()
        let message = "some message"
        let thread = "main"
        let function = "test()"
        let file = "MainVC"
        let line = 123

        let log = TLog(loggerID: loggerId,
                       level: .debug,
                       date: expectedDate,
                       message: { return message },
                       threadName: thread,
                       functionName: function,
                       fileName: file,
                       lineNumber: line,
                       userInfo: nil)

        let jsonDict = formatter.json(for: log)

        XCTAssertEqual((jsonDict["logger_id"] as! String), loggerId)
        XCTAssertEqual((jsonDict["level"] as! String), level)
        XCTAssertEqual((jsonDict["date"] as! String),
                       formatter.dateFormatter.string(from: log.date))
        XCTAssertEqual((jsonDict["message"] as! String), message)
        XCTAssertEqual((jsonDict["thread"] as! String), thread)
        XCTAssertEqual((jsonDict["function"] as! String), function)
        XCTAssertEqual((jsonDict["file"] as! String), file)
        XCTAssertEqual((jsonDict["line"] as! Int), line)
    }

    func testLogToJSONWithUserInfo() {
        let loggerId = "logger_id"
        let level = TLogLevel.debug.name
        let expectedDate = Date()
        let message = "some message"
        let thread = "main"
        let function = "test()"
        let file = "MainVC"
        let line = 123
        let userInfo = ["one": self]

        let log = TLog(loggerID: loggerId,
                       level: .debug,
                       date: expectedDate,
                       message: { return message },
                       threadName: thread,
                       functionName: function,
                       fileName: file,
                       lineNumber: line,
                       userInfo: userInfo)

        let jsonDict = formatter.json(for: log)

        XCTAssertEqual((jsonDict["logger_id"] as! String), loggerId)
        XCTAssertEqual((jsonDict["level"] as! String), level)
        XCTAssertEqual((jsonDict["date"] as! String),
                       formatter.dateFormatter.string(from: log.date))
        XCTAssertEqual((jsonDict["message"] as! String), message)
        XCTAssertEqual((jsonDict["thread"] as! String), thread)
        XCTAssertEqual((jsonDict["function"] as! String), function)
        XCTAssertEqual((jsonDict["file"] as! String), file)
        XCTAssertEqual((jsonDict["line"] as! Int), line)

        XCTAssertEqual((jsonDict["user_info"] as! [String: String]),
                       ["one": "-[TLogDefaultJSONFormatterTests testLogToJSONWithUserInfo]"])
    }

    func testLogToJSONObject() {
        let loggerId = "logger_id"
        let expectedDate = Date()
        let message = "some message"
        let thread = "main"
        let function = "test()"
        let file = "MainVC"
        let line = 123
        let userInfo = ["one": self]

        let log = TLog(loggerID: loggerId,
                       level: .debug,
                       date: expectedDate,
                       message: { return message },
                       threadName: thread,
                       functionName: function,
                       fileName: file,
                       lineNumber: line,
                       userInfo: userInfo)

        let jsonDict = formatter.json(for: log)

        let expectedJsonData = try! JSONSerialization.data(withJSONObject: jsonDict)

        let logData = formatter.jsonObject(for: log)

        XCTAssertEqual(logData, expectedJsonData)
    }

    func testFormatLogMethod() {
        let loggerId = "logger_id"
        let level = TLogLevel.debug.name
        let expectedDate = Date()
        let message = "some message"
        let thread = "main"
        let function = "test()"
        let file = "MainVC"
        let line = 123
        let userInfo = ["one": self]

        let log = TLog(loggerID: loggerId,
                       level: .debug,
                       date: expectedDate,
                       message: { return message },
                       threadName: thread,
                       functionName: function,
                       fileName: file,
                       lineNumber: line,
                       userInfo: userInfo)

        XCTAssertTrue(formatter.format(log) is TamboJSONType)

        let jsonDict = formatter.format(log) as! TamboJSONType

        XCTAssertEqual((jsonDict["logger_id"] as! String), loggerId)
        XCTAssertEqual((jsonDict["level"] as! String), level)
        XCTAssertEqual((jsonDict["date"] as! String),
                       formatter.dateFormatter.string(from: log.date))
        XCTAssertEqual((jsonDict["message"] as! String), message)
        XCTAssertEqual((jsonDict["thread"] as! String), thread)
        XCTAssertEqual((jsonDict["function"] as! String), function)
        XCTAssertEqual((jsonDict["file"] as! String), file)
        XCTAssertEqual((jsonDict["line"] as! Int), line)

        XCTAssertEqual((jsonDict["user_info"] as! [String: String]),
                       ["one": "-[TLogDefaultJSONFormatterTests testFormatLogMethod]"])
    }

    func testInfavlidJSONData() {
        let log = TLog(loggerID: "loggerId",
                       level: .debug,
                       date: Date(),
                       message: { return "message" },
                       threadName: "thread",
                       functionName: "function",
                       fileName: "file",
                       lineNumber: 77,
                       userInfo: nil)
        let invalidJSONFormatter = InvalidJSONFormatter()
        let invalidJSONDict = invalidJSONFormatter.json(for: log)
        XCTAssertFalse(JSONSerialization.isValidJSONObject(invalidJSONDict))
        XCTAssertNoThrow(invalidJSONFormatter.jsonObject(for: log))
    }
}

class InvalidJSONFormatter: TLogDefaultJSONFormatter {
    override func json(for log: TLog) -> TamboJSONType {
        return ["one": self]
    }
}
