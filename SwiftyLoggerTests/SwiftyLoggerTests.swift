//
//  SwiftyLoggerTests.swift
//  SwiftyLoggerTests
//
//  Created by Massimo Donati on 7/23/18.
//

import XCTest
import SwiftyLogger

class SwiftyLoggerTests: XCTestCase {
    var logger: SLLogger!
    override func setUp() {
        super.setUp()

    }
    
    override func tearDown() {
        logger = nil
        super.tearDown()
    }
    
    func testOSLogInfoLevel() {
        logger = SLLogger(identifier: "loggerIdentifier")
        let osLog = SLOSLogDestination(identifier: "os_log",
                                       subsystem: "logger.test.subsystem",
                                       category: "logger.test.category")
        logger.addDestination(osLog)
        logger.info("ciccio", userInfo: ["some": "info", "test": self])
    }

    func testXcodeConsoleInfoLevel() {
        logger = SLLogger(identifier: "loggerIdentifier")
        logger.isAsync = false
        let consolDest = SLConsoleDestination(identifier: "consoleID",
                                              formatterOption: .default,
                                              printMode: .print)

        logger.addDestination(consolDest)
        DispatchQueue.concurrentPerform(iterations: 2) { _ in
            logger.info("", userInfo: ["some": 2, "test": self])
        }
    }
}
