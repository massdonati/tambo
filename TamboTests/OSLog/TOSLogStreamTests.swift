//
//  TOSLogStreamTests.swift
//  Tambo
//
//  Created by Massimo Donati on 8/14/18.
//

import XCTest
@testable import Tambo

class TOSLogStreamTests: XCTestCase {

    override func setUp() {
        // Put setup code here.
    }

    override func tearDown() {
        // Put teardown code here.
    }

    func testOSLogging() {
        let osLogStream = TOSLogStream(identifier: "some_id",
                                       subsystem: "subsystem",
                                       category:"category")

        XCTAssertEqual(osLogStream.logFormatter.logFormat, TOSLogStream.osLogFormat)

        let log = Tambo(identifier: "test-logger")


        log.add(stream: osLogStream)
        log.debug("some debug message")

    }
}
