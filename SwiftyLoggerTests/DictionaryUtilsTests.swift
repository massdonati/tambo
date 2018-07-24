//
//  DictionaryUtilsTests.swift
//  SwiftyLoggerTests
//
//  Created by Massimo Donati on 7/25/18.
//

import XCTest
@testable import SwiftyLogger

class DictionaryUtilsTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here.
    }

    override func tearDown() {
        // Put teardown code here.
        super.tearDown()
    }

    func testJasonify() {
        var invalidJSONDict = ["key": self]
        XCTAssertFalse(JSONSerialization.isValidJSONObject(invalidJSONDict))

        invalidJSONDict.jsonify()

        XCTAssertTrue(JSONSerialization.isValidJSONObject(invalidJSONDict))
    }
}
