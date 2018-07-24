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
        logger = SLLogger(identifier: "loggerIdentifier")
        let osLog = SLOSLogDestination(identifier: "os_log",
                                       subsystem: "logger.test.subsystem",
                                       category: "logger.test.category")
        logger.destinations.append(osLog)
    }
    
    override func tearDown() {
        logger = nil
        super.tearDown()
    }
    
    func testLogInfoLevel() {
        logger.info("ciccio", userInfo: ["some": "info", "test": self])
    }
}
