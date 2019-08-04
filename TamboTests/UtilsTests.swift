//
//  DictionaryUtilsTests.swift
//  TamboTests
//
//  Created by Massimo Donati on 7/25/18.
//

import XCTest
@testable import Tambo

class UtilsTests: XCTestCase {

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

        invalidJSONDict.makeJsonEncodable()

        XCTAssertTrue(JSONSerialization.isValidJSONObject(invalidJSONDict))

        XCTAssertEqual(invalidJSONDict["number"] as? Int, 2,
                       "the jsonify method whould not change any already `Encodable` types")
    }

    func testFileNameFromPath() {
        let invalidPath = ""
        let fileName1 = Utility.filename(from: invalidPath)
        XCTAssertNil(fileName1)
        let fileName2 = Utility.filename(from: invalidPath,
                                         chopExtension: false)
        XCTAssertNil(fileName2)

        let validPath = "/Users/massimo/Projects/Tambo/TamboTests/OSLog/TOSLogStreamTests.swift"

        let fileName3 = Utility.filename(from: validPath,
                                         chopExtension: false)

        XCTAssertNotNil(fileName3)
        XCTAssertEqual(fileName3, "TOSLogStreamTests.swift")

        let fileName4 = Utility.filename(from: validPath)

        XCTAssertNotNil(fileName4)
        XCTAssertEqual(fileName4, "TOSLogStreamTests")
    }

    func testFileNameFromPathWithSpaces() {
        let fileName = "TOSLogStreamTests"
        let invalidPath = "/Users/massimo/Projects/Tambo/Tambo Tests/OSLog/\(fileName).swift"
        let fileName1 = Utility.filename(from: invalidPath)
        XCTAssertNotNil(fileName1)
        XCTAssertEqual(fileName, fileName1)
    }

    func testThreadName() {
        XCTAssertEqual(Utility.threadName(), "main_thread")

        var emptyNameThreadExecuted = false
        let exp1 = expectation(description: "wait for empty name thread to run")
        let emptyNameThread = Thread {
            // this would look something like
            // "<NSThread: 0x103709a10>{number = 2, name = }"
            XCTAssertNotEqual(Utility.threadName(), "")
            emptyNameThreadExecuted = true
            exp1.fulfill()
        }
        emptyNameThread.name = ""
        emptyNameThread.start()


        var actualNameThreadExecuted = false
        let threadName = "some_thread_name"
        let exp2 = expectation(description: "wait for actual name thread to run")
        let actualNameThread = Thread {
            XCTAssertEqual(Utility.threadName(), threadName)
            actualNameThreadExecuted = true
            exp2.fulfill()
        }
        actualNameThread.name = threadName
        actualNameThread.start()
        wait(for: [exp1, exp2], timeout: 3)
        XCTAssertTrue(actualNameThreadExecuted)
        XCTAssertTrue(emptyNameThreadExecuted)
    }
}
