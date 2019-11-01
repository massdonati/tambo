//
//  TLogTests.swift
//  Tambo
//
//  Created by Massimo Donati on 8/5/18.
//

import XCTest
@testable import Tambo

class TLogTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here.
    }

    override func tearDown() {
        // Put teardown code here.
        super.tearDown()
    }

    func testcontextJSONString() {
        var context: [String: Any] = ["test_instance": self, "val": 2]
        let log = TLog(loggerID: "some.logger",
                       level: .trace,
                       date: Date(),
                       message: { return "" },
                       condition: true,
                       threadName: "main",
                       functionName: "test()",
                       filePath: "TLogTests",
                       lineNumber: 24,
                       context: context
        )

        context.makeValidJsonObject()
        XCTAssertNoThrow(try JSONSerialization.data(withJSONObject: context,
                                                    options: .prettyPrinted))

        let jsonData = try! JSONSerialization.data(withJSONObject: context,
                                                   options: .prettyPrinted)

        let expectedJSONString = String(data: jsonData, encoding: .utf8)!

        XCTAssertNoThrow(log.contextJSONString)
        let str = log.contextJSONString
        XCTAssertEqual(str, expectedJSONString)
    }

    func testNilcontextJSONString() {
        let log = TLog(loggerID: "some.logger",
                       level: .trace,
                       date: Date(),
                       message: { return "" },
                       condition: true,
                       threadName: "main",
                       functionName: "test()",
                       filePath: "TLogTests",
                       lineNumber: 24,
                       context: nil)

        XCTAssertNoThrow(log.contextJSONString)
        XCTAssertNil(log.contextJSONString)
    }

    func testEmptyFileName() {
        let log = TLog(loggerID: "some.logger",
                       level: .trace,
                       date: Date(),
                       message: { return "" },
                       condition: true,
                       threadName: "main",
                       functionName: "test()",
                       filePath: "",
                       lineNumber: 24,
                       context: nil)

        XCTAssertEqual(log.fileName, "")
    }
}
