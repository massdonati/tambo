//
//  TOSLogTypeMapperTests.swift
//  Tambo
//
//  Created by Massimo Donati on 8/9/18.
//

import XCTest
import os
@testable import Tambo

class TOSLogTypeMapperTests: XCTestCase {

    override func setUp() {
        // Put setup code here.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here.
        super.tearDown()
    }

    func testTLogLevelToOsLevel() {
        let defaultMapping = TOSLogTypeMapper.default

        XCTAssertEqual(defaultMapping.osLogType(for: .verbose), .debug)
        XCTAssertEqual(defaultMapping.osLogType(for: .debug), .debug)
        XCTAssertEqual(defaultMapping.osLogType(for: .info), .info)
        XCTAssertEqual(defaultMapping.osLogType(for: .warning), .error)
        XCTAssertEqual(defaultMapping.osLogType(for: .error), .fault)

        let custom = TOSLogTypeMapper.function(customMapping)

        XCTAssertEqual(custom.osLogType(for: .verbose), .default)
        XCTAssertEqual(custom.osLogType(for: .debug), .default)
        XCTAssertEqual(custom.osLogType(for: .info), .default)
        XCTAssertEqual(custom.osLogType(for: .warning), .default)
        XCTAssertEqual(custom.osLogType(for: .error), .default)
    }

    func customMapping(_ level: TLogLevel) -> OSLogType {
        switch level {
        case .verbose: return .default
        case .debug: return .default
        case .info: return .default
        case .warning: return .default
        case .error: return .default
        }
    }
}
