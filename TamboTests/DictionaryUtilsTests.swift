//
//  DictionaryUtilsTests.swift
//  TamboTests
//
//  Created by Massimo Donati on 7/25/18.
//

import XCTest
@testable import Tambo

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
        var invalidJSONDict: [String: Any] = ["key": self, "number": 2]
        XCTAssertFalse(JSONSerialization.isValidJSONObject(invalidJSONDict))

        invalidJSONDict.jsonify()

        XCTAssertTrue(JSONSerialization.isValidJSONObject(invalidJSONDict))

        XCTAssertEqual(invalidJSONDict["number"] as? Int, 2,
                       "the jsonify method whould not change any already `Encodable` types")
    }
}
