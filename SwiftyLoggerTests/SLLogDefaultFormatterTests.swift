//
//  SLLogDefaultFormatterTests.swift
//  SwiftyLogger
//
//  Created by Massimo Donati on 7/26/18.
//

import XCTest
@testable import SwiftyLogger

class SLLogDefaultFormatterTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here.
    }

    override func tearDown() {
        // Put teardown code here.
        super.tearDown()
    }

    func testExample() {
        let formatter = SLLogDefaultFormatter()
        let format = formatter.format
        let log = SLLog(level: .info,
                        date: Date(),
                        message: "",
                        threadName: "main", functionName: "ciccio",
                        fileName: "Ciccio.swift",
                        lineNumber: 12,
                        userInfo: ["ciccio": "ciccio"])

        _ = formatter.string(for: log)

        XCTAssertEqual(format, formatter.format)
    }
}
