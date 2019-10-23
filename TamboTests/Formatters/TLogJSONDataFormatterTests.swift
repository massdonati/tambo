//
//  TLogJSONDataFormatter.swift
//  Tambo
//
//  Created by Massimo Donati on 8/9/18.
//

import XCTest
@testable import Tambo

class TLogJSONDataFormatterTests: XCTestCase {
    var formatter: TLogJSONFormatter!

    override func setUp() {
        super.setUp()
        formatter = TLogJSONFormatter()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testLogToJSONObject() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        formatter = TLogJSONFormatter(
            with: TLogToJSONConverter(dateFormatter: dateFormatter)
        )

        let logTimestamp = Date()
        let log = TLog(loggerID: "logger_id",
                       level: .debug,
                       date: logTimestamp,
                       message: { return "some message" },
                       condition: true,
                       threadName: "main",
                       functionName: "test()",
                       filePath: "/proj/MainVC.swift",
                       lineNumber: 123,
                       context: ["one": self])

        let expectedJsonString = """
            {"context":{"one":"-[TLogJSONDataFormatterTests testLogToJSONObject]"},\
            "date":"\(dateFormatter.string(from: logTimestamp))",\
            "file":"MainVC",\
            "function":"test()",\
            "level":"debug",\
            "line":123,\
            "logger_id":"logger_id",\
            "message":"some message",\
            "thread":"main"}
            """

        let logData = formatter.format(log)
        let logJSONSstring = String(data: logData, encoding: .utf8)!
        XCTAssertEqual(logJSONSstring, expectedJsonString)
    }

    func testInvalidJSONObject() {
        var invalidJSONObject = ["ciccio": NSObject()]

        XCTAssertFalse(JSONSerialization.isValidJSONObject(invalidJSONObject))

        let log = TLog(loggerID: "loggerId",
                       level: .debug,
                       date: Date(),
                       message: { return "message" },
                       condition: true,
                       threadName: "thread",
                       functionName: "function",
                       filePath: "/proj/file.swift",
                       lineNumber: 12,
                       context: nil)

        let jsonConverter = JSONConverterMock()
        let jsonDataFormatter = TLogJSONFormatter(with: jsonConverter)

        jsonConverter.jsonDict = invalidJSONObject

        invalidJSONObject.makeValidJsonObject()

        let expectedJsonData = try! JSONSerialization
            .data(withJSONObject: invalidJSONObject)

        let jsonData = jsonDataFormatter.format(log)

        XCTAssertEqual(jsonData, expectedJsonData)
    }
}
