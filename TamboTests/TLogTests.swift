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

    func testUserInfoJSONString() {
        var userInfo: [String: Any] = ["test_instance": self, "val": 2]
        let log = TLog(loggerID: "some.logger",
                       level: .verbose,
                       date: Date(),
                       message: { return "" },
                       threadName: "main",
                       functionName: "test()",
                       filePath: "TLogTests",
                       lineNumber: 24,
                       userInfo: userInfo)

        userInfo.jsonify()
        XCTAssertNoThrow(try JSONSerialization.data(withJSONObject: userInfo,
                                                    options: .prettyPrinted))

        let jsonData = try! JSONSerialization.data(withJSONObject: userInfo,
                                                   options: .prettyPrinted)

        let expectedJSONString = String(data: jsonData, encoding: .utf8)!

        XCTAssertNoThrow(log.userInfoJSONString)
        let str = log.userInfoJSONString
        XCTAssertEqual(str, expectedJSONString)
    }

    func testNilUserInfoJSONString() {
        let log = TLog(loggerID: "some.logger",
                       level: .verbose,
                       date: Date(),
                       message: { return "" },
                       threadName: "main",
                       functionName: "test()",
                       filePath: "TLogTests",
                       lineNumber: 24,
                       userInfo: nil)

        XCTAssertNoThrow(log.userInfoJSONString)
        XCTAssertNil(log.userInfoJSONString)
    }
}
