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
        XCTAssertFalse(stream.isEnabled(for: .verbose))
        XCTAssertFalse(stream.isEnabled(for: .debug))
        XCTAssertTrue(stream.isEnabled(for: .info))
        XCTAssertTrue(stream.isEnabled(for: .warning))
        XCTAssertTrue(stream.isEnabled(for: .error))

        stream.outputLevel = .verbose
        XCTAssertTrue(stream.isEnabled(for: .verbose))
        XCTAssertTrue(stream.isEnabled(for: .debug))
        XCTAssertTrue(stream.isEnabled(for: .info))
        XCTAssertTrue(stream.isEnabled(for: .warning))
        XCTAssertTrue(stream.isEnabled(for: .error))
    }
}
