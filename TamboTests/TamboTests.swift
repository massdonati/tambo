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
        let osLog = TOSLogStream(identifier: "os_log",
                                 subsystem: "logger.test.subsystem",
                                 category: "logger.test.category")
        logger.addDestination(osLog)
        logger.info("ciccio", userInfo: ["some": "info", "test": self])
    }

    func testXcodeConsoleInfoLevel() {
        logger = Tambo(identifier: "loggerIdentifier")
        logger.isAsync = false
        let consolDest = TConsoleStream(identifier: "consoleID",
                                        formatterOption: .default,
                                        printMode: .print)

        logger.addDestination(consolDest)
        DispatchQueue.concurrentPerform(iterations: 2) { _ in
            logger.info("", userInfo: ["some": 2, "test": self])
        }
    }
}
