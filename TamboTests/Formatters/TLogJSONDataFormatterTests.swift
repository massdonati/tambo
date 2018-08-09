//
//  TLogJSONDataFormatter.swift
//  Tambo
//
//  Created by Massimo Donati on 8/9/18.
//

import XCTest
@testable import Tambo

class TLogJSONDataFormatterTests: XCTestCase {
    var formatter: TLogJSONDataFormatter!
    override func setUp() {
        formatter = TLogJSONDataFormatter()
    }

    override func tearDown() {
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

        let jsonDict = TLogJSONDictionaryFormatter().format(log)

        let expectedJsonData = try! JSONSerialization.data(withJSONObject: jsonDict)

        let logData = formatter.format(log)

        XCTAssertEqual(logData, expectedJsonData)
    }
}
