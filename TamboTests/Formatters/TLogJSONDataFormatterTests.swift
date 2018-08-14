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
        super.setUp()
        formatter = TLogJSONDataFormatter()
    }

    override func tearDown() {
        super.tearDown()
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

        let jsonDict = TLogToJSONConverter().dictionary(from: log)

        let expectedJsonData = try! JSONSerialization.data(withJSONObject: jsonDict)

        let logData = formatter.format(log)

        XCTAssertEqual(logData, expectedJsonData)
    }

    func testInvalidJSONObject() {
        var invalidJSONObject = ["ciccio": NSObject()]

        XCTAssertFalse(JSONSerialization.isValidJSONObject(invalidJSONObject))

        let log = TLog(loggerID: "loggerId",
                       level: .debug,
                       date: Date(),
                       message: { return "message" },
                       threadName: "thread",
                       functionName: "function",
                       fileName: "file",
                       lineNumber: 12,
                       userInfo: nil)

        let jsonConverter = JSONConverterMock()
        let jsonDataFormatter = TLogJSONDataFormatter(with: jsonConverter)

        jsonConverter.jsonDict = invalidJSONObject

        invalidJSONObject.jsonify()

        let expectedJsonData = try! JSONSerialization
            .data(withJSONObject: invalidJSONObject)

        let jsonData = jsonDataFormatter.format(log)

        XCTAssertEqual(jsonData, expectedJsonData)


    }
}
