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
        let defaultMapping = OSLogTypeMapper.default

        XCTAssertEqual(defaultMapping.osLogType(for: .trace), .debug)
        XCTAssertEqual(defaultMapping.osLogType(for: .debug), .debug)
        XCTAssertEqual(defaultMapping.osLogType(for: .info), .info)
        XCTAssertEqual(defaultMapping.osLogType(for: .warning), .error)
        XCTAssertEqual(defaultMapping.osLogType(for: .error), .fault)

        let custom = OSLogTypeMapper.function(customMapping)

        XCTAssertEqual(custom.osLogType(for: .trace), .default)
        XCTAssertEqual(custom.osLogType(for: .debug), .default)
        XCTAssertEqual(custom.osLogType(for: .info), .default)
        XCTAssertEqual(custom.osLogType(for: .warning), .default)
        XCTAssertEqual(custom.osLogType(for: .error), .default)
    }

    func customMapping(_ level: LogLevel) -> OSLogType {
        switch level {
        case .trace: return .default
        case .debug: return .default
        case .info: return .default
        case .warning: return .default
        case .error: return .default
        }
    }
}
