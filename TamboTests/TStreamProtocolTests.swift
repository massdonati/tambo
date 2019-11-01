//
//  TStreamProtocolTests.swift
//  Tambo
//
//  Created by Massimo Donati on 8/9/18.
//

import XCTest
import Tambo

class TStreamProtocolTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIsEnabledForLevel() {
        let stream = StreamMock()
        stream.outputLevel = .info
        XCTAssertFalse(stream.isEnabled(for: .trace))
        XCTAssertFalse(stream.isEnabled(for: .debug))
        XCTAssertTrue(stream.isEnabled(for: .info))
        XCTAssertTrue(stream.isEnabled(for: .warning))
        XCTAssertTrue(stream.isEnabled(for: .error))

        stream.outputLevel = .trace
        XCTAssertTrue(stream.isEnabled(for: .trace))
        XCTAssertTrue(stream.isEnabled(for: .debug))
        XCTAssertTrue(stream.isEnabled(for: .info))
        XCTAssertTrue(stream.isEnabled(for: .warning))
        XCTAssertTrue(stream.isEnabled(for: .error))
    }

    func testStreamMetadata() {
        let logger = Tambo(identifier: "test")
        let stream = StreamMock()
        var tLog: TLog!
        let exp = XCTestExpectation(
            description: "wait for the process closure to be called"
        )
        stream.processClosure = { log in
            tLog = log
            exp.fulfill()
        }
        stream.metadata = ["os_version": "1.2.3"]
        logger.add(stream: stream)
        logger.info("test log message")

        _ = XCTWaiter.wait(for: [exp], timeout: 3)

        XCTAssertNotNil(tLog)
        let context = tLog.context!
        XCTAssertNotNil(context["metadata"])
        XCTAssertTrue(context["metadata"] is [String: Any])
        let metadata = context["metadata"] as! [String: Any]
        XCTAssertEqual(metadata.keys.count, 1)
        XCTAssertEqual(metadata["os_version"] as! String, "1.2.3")
    }
}

