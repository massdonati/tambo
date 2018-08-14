//
//  TOSLogStreamTests.swift
//  Tambo
//
//  Created by Massimo Donati on 8/14/18.
//

import XCTest
import Tambo

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
        Tambo.default.removeAllStreams()
        Tambo.default.add(stream: osLogStream)
        Tambo.default.debug("some debug message")
    }
}
