//
//  TLogDefaultJSONFormatterTests.swift
//  Tambo
//
//  Created by Massimo Donati on 8/5/18.
//

import XCTest
@testable import Tambo

class TLogToJSONConverterTests: XCTestCase {
    var converter: TLogToJSONConverter!
    override func setUp() {
        super.setUp()
        converter = TLogToJSONConverter()
    }

    override func tearDown() {
        converter = nil
        super.tearDown()
    }

    func testDefaultDateFormatterFormat() {
        XCTAssertEqual(converter.dateFormatter.dateFormat,
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

        let jsonDict = converter.dictionary(from: log)

        XCTAssertEqual((jsonDict["logger_id"] as! String), loggerId)
        XCTAssertEqual((jsonDict["level"] as! String), level)
        XCTAssertEqual((jsonDict["date"] as! String),
                       converter.dateFormatter.string(from: log.date))
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

        let jsonDict = converter.dictionary(from: log)

        XCTAssertEqual((jsonDict["logger_id"] as! String), loggerId)
        XCTAssertEqual((jsonDict["level"] as! String), level)
        XCTAssertEqual((jsonDict["date"] as! String),
                       converter.dateFormatter.string(from: log.date))
        XCTAssertEqual((jsonDict["message"] as! String), message)
        XCTAssertEqual((jsonDict["thread"] as! String), thread)
        XCTAssertEqual((jsonDict["function"] as! String), function)
        XCTAssertEqual((jsonDict["file"] as! String), file)
        XCTAssertEqual((jsonDict["line"] as! Int), line)

        XCTAssertEqual((jsonDict["user_info"] as! [String: String]),
                       ["one": "-[TLogToJSONConverterTests testLogToJSONWithUserInfo]"])
    }
}
