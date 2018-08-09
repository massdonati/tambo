//
//  TamboTests.swift
//  TamboTests
//
//  Created by Massimo Donati on 7/23/18.
//

import XCTest
import Tambo

class TamboTests: XCTestCase {
    var logger: Tambo!
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        logger = nil
        super.tearDown()
    }
    
    func testOSLogInfoLevel() {
        logger = Tambo(identifier: "loggerIdentifier")
        let osLog = TOSLogStream(
            identifier: "os_log",
            subsystem: "logger.test.subsystem",
            category: "logger.test.category"
        )
        logger.add(stream: osLog)
        logger.info("ciccio", userInfo: ["some": "info", "test": self])
    }

    func testXcodeConsoleInfoLevel() {
        logger = Tambo(identifier: "loggerIdentifier")
        let consoleStream = TConsoleStream(
            identifier: "consoleID",
            printMode: .print
        )
        consoleStream.isAsync = false

        logger.add(stream: consoleStream)
        DispatchQueue.concurrentPerform(iterations: 2) { _ in
            XCTAssertNoThrow(
                logger.info("", userInfo: ["some": 2, "test": self]), """
                Placing `self` in the userInfo dictionary should not throw:
                the conversation to JSON should convert `self` with the string
                description i.e. "-[TamboTests testOSLogInfoLevel]".
                """)
        }
    }
}
