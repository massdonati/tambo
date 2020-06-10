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
        let level = LogLevel.debug.name
        let expectedDate = Date()
        let message = "some message"
        let thread = "main"
        let function = "test()"
        let filePath = "/proj/MainVC.swift"
        let line = 123

        let log = Log(loggerID: loggerId,
                       level: .debug,
                       date: expectedDate,
                       message: { return message },
                       condition: true,
                       threadName: thread,
                       functionName: function,
                       filePath: filePath,
                       lineNumber: line,
                       context: nil)

        let jsonDict = converter.dictionary(from: log)
        let fileName = Utility.filename(from: filePath)

        XCTAssertEqual((jsonDict["logger_id"] as! String), loggerId)
        XCTAssertEqual((jsonDict["level"] as! String), level)
        XCTAssertEqual((jsonDict["date"] as! String),
                       converter.dateFormatter.string(from: log.date))
        XCTAssertEqual((jsonDict["message"] as! String), message)
        XCTAssertEqual((jsonDict["thread"] as! String), thread)
        XCTAssertEqual((jsonDict["function"] as! String), function)
        XCTAssertEqual((jsonDict["file"] as! String), fileName)
        XCTAssertEqual((jsonDict["line"] as! Int), line)
    }

    func testLogToJSONWithUserInfo() {
        let loggerId = "logger_id"
        let level = LogLevel.debug.name
        let expectedDate = Date()
        let message = "some message"
        let thread = "main"
        let function = "test()"
        let filePath = "/proj/MainVC.swift"
        let line = 123
        let userInfo = ["one": self]

        let log = Log(loggerID: loggerId,
                       level: .debug,
                       date: expectedDate,
                       message: { return message },
                       condition: true,
                       threadName: thread,
                       functionName: function,
                       filePath: filePath,
                       lineNumber: line,
                       context: userInfo)

        let jsonDict = converter.dictionary(from: log)
        let fileName = Utility.filename(from: filePath)

        XCTAssertEqual((jsonDict["logger_id"] as! String), loggerId)
        XCTAssertEqual((jsonDict["level"] as! String), level)
        XCTAssertEqual((jsonDict["date"] as! String),
                       converter.dateFormatter.string(from: log.date))
        XCTAssertEqual((jsonDict["message"] as! String), message)
        XCTAssertEqual((jsonDict["thread"] as! String), thread)
        XCTAssertEqual((jsonDict["function"] as! String), function)
        XCTAssertEqual((jsonDict["file"] as! String), fileName)
        XCTAssertEqual((jsonDict["line"] as! Int), line)

        XCTAssertEqual((jsonDict["context"] as! [String: String]),
                       ["one": "-[TLogToJSONConverterTests testLogToJSONWithUserInfo]"])
    }
}
