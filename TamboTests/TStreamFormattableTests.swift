//
//  TStreamFormattableTests.swift
//  Tambo
//
//  Created by Massimo Donati on 8/9/18.
//

import XCTest

class TStreamFormattableTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDefaultProcessMethod() {
        let formatStream = FormattableStreamMock()
        formatStream.logFormatter.formattedLogString = "some string"
        formatStream.isAsync = false
        var outputLogClosureCalled = false
        formatStream.outputLogClosure = { log, logString in
            outputLogClosureCalled = true
        }

        formatStream.process(logMock)

        XCTAssertTrue(outputLogClosureCalled)

        formatStream.isAsync = true
        outputLogClosureCalled = false
        let exp = expectation(description: "Wait for async output")
        formatStream.outputLogClosure = { log, logString in
            outputLogClosureCalled = true
            exp.fulfill()
        }

        formatStream.process(logMock)

        XCTAssertFalse(outputLogClosureCalled)

        waitForExpectations(timeout: 0.5) { error in
            if let err = error {
                XCTFail("timeout with error: \(err)")
            }
        }
    }
}
