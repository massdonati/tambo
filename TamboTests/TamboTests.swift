//
//  TamboTests.swift
//  TamboTests
//
//  Created by Massimo Donati on 7/23/18.
//

import XCTest
import Tambo

class TamboTests: XCTestCase {
    var logger: Tambo!

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        logger = nil
        super.tearDown()
    }

    func testDefaultTambo() {
        logger = Tambo.default
        logger.removeAllStreams()
        let mockStream = StreamMock()
        mockStream.outputLevel = .verbose
        logger.add(stream: mockStream)
        let userinfo: TJSONType = ["some": "info", "test": self]
        let message = "ciccio"

        let exp = expectation(description: "Wait for the log to be processed")
        var processClosureCalled = false
        mockStream.processClosure = { log in
            XCTAssertEqual(log.level, .info)
            XCTAssertEqual(log.message() as! String, message)
            XCTAssertEqual(log.userInfo!.keys.count, 2)
            XCTAssertEqual(log.userInfo!["some"] as! String, "info")
            XCTAssertEqual(log.userInfo!["test"] as! XCTestCase, self)
            processClosureCalled = true
            exp.fulfill()
        }

        logger.info(message, userInfo: userinfo)

        waitForExpectations(timeout: 6) { error in
            guard let err = error else { return }
            XCTFail("Expectation timed out with error: \(String(describing: err))")
        }

        XCTAssertTrue(processClosureCalled)
    }

    func testStreamNotEnabledForLevel() {
        XCTAssertTrue(Tambo.default === Tambo.default)
        logger = Tambo.default
        logger.removeAllStreams()
        let mockStream = StreamMock()
        mockStream.outputLevel = .info
        logger.add(stream: mockStream)
        let userinfo: TJSONType = ["some": "info", "test": self]
        let message = "ciccio"

        let exp = expectation(description: "Wait for the log to be processed")
        mockStream.processClosure = { log in
            XCTFail("""
                with an `info` outputLevel the stream should not procees a \
                verbose message
                """)
        }

        logger.verbose(message, userInfo: userinfo)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exp.fulfill()
        }

        waitForExpectations(timeout: 6) { error in
            guard let err = error else { return }
            XCTFail("Expectation timed out with error: \(String(describing: err))")
        }
    }

    func testStreamSholdNotProcess() {
        logger = Tambo.default
        logger.removeAllStreams()
        let mockStream = StreamMock()
        mockStream.outputLevel = .verbose
        logger.add(stream: mockStream)
        let userinfo: TJSONType = ["some": "info", "test": self]
        let message = "ciccio"

        let exp = expectation(description: "Wait for the log to be processed")
        mockStream.processClosure = { log in
            XCTFail("""
                with an `info` outputLevel the stream should not procees a \
                verbose message
                """)
        }
        var shouldProcessClosureCalled = false
        mockStream.shouldFilterClosure = { _ in
            shouldProcessClosureCalled = true
            return true
        }

        logger.verbose(message, userInfo: userinfo)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            exp.fulfill()
        }

        waitForExpectations(timeout: 6) { error in
            guard let err = error else { return }
            XCTFail("Expectation timed out with error: \(String(describing: err))")
        }

        XCTAssertTrue(shouldProcessClosureCalled)
    }

    func testVerboseLevel() {
        logger = Tambo.default
        logger.removeAllStreams()
        let mockStream = StreamMock()
        mockStream.outputLevel = .verbose
        logger.add(stream: mockStream)
        let userinfo: TJSONType = ["some": "info", "test": self]
        let message = "ciccio"

        let exp = expectation(description: "Wait for the log to be processed")
        var processClosureCalled = false
        mockStream.processClosure = { log in
            XCTAssertEqual(log.level, .verbose)
            XCTAssertEqual(log.message() as! String, message)
            XCTAssertEqual(log.userInfo!.keys.count, 2)
            XCTAssertEqual(log.userInfo!["some"] as! String, "info")
            XCTAssertEqual(log.userInfo!["test"] as! XCTestCase, self)
            processClosureCalled = true
            exp.fulfill()
        }

        logger.verbose(message, userInfo: userinfo)

        waitForExpectations(timeout: 6) { error in
            guard let err = error else { return }
            XCTFail("Expectation timed out with error: \(String(describing: err))")
        }

        XCTAssertTrue(processClosureCalled)
    }

    func testDebugLevel() {
        logger = Tambo.default
        logger.removeAllStreams()
        let mockStream = StreamMock()
        mockStream.outputLevel = .verbose
        logger.add(stream: mockStream)
        let userinfo: TJSONType = ["some": "info", "test": self]
        let message = "ciccio"

        let exp = expectation(description: "Wait for the log to be processed")
        var processClosureCalled = false
        mockStream.processClosure = { log in
            XCTAssertEqual(log.level, .debug)
            XCTAssertEqual(log.message() as! String, message)
            XCTAssertEqual(log.userInfo!.keys.count, 2)
            XCTAssertEqual(log.userInfo!["some"] as! String, "info")
            XCTAssertEqual(log.userInfo!["test"] as! XCTestCase, self)
            processClosureCalled = true
            exp.fulfill()
        }

        logger.debug(message, userInfo: userinfo)

        waitForExpectations(timeout: 6) { error in
            guard let err = error else { return }
            XCTFail("Expectation timed out with error: \(String(describing: err))")
        }

        XCTAssertTrue(processClosureCalled)
    }

    func testInfoLevel() {
        logger = Tambo.default
        logger.removeAllStreams()
        let mockStream = StreamMock()
        mockStream.outputLevel = .verbose
        logger.add(stream: mockStream)
        let userinfo: TJSONType = ["some": "info", "test": self]
        let message = "ciccio"

        let exp = expectation(description: "Wait for the log to be processed")
        var processClosureCalled = false
        mockStream.processClosure = { log in
            XCTAssertEqual(log.level, .info)
            XCTAssertEqual(log.message() as! String, message)
            XCTAssertEqual(log.userInfo!.keys.count, 2)
            XCTAssertEqual(log.userInfo!["some"] as! String, "info")
            XCTAssertEqual(log.userInfo!["test"] as! XCTestCase, self)
            processClosureCalled = true
            exp.fulfill()
        }

        logger.info(message, userInfo: userinfo)

        waitForExpectations(timeout: 6) { error in
            guard let err = error else { return }
            XCTFail("Expectation timed out with error: \(String(describing: err))")
        }

        XCTAssertTrue(processClosureCalled)
    }

    func testWarningLevel() {
        logger = Tambo.default
        logger.removeAllStreams()
        let mockStream = StreamMock()
        mockStream.outputLevel = .verbose
        logger.add(stream: mockStream)
        let userinfo: TJSONType = ["some": "info", "test": self]
        let message = "ciccio"

        let exp = expectation(description: "Wait for the log to be processed")
        var processClosureCalled = false
        mockStream.processClosure = { log in
            XCTAssertEqual(log.level, .warning)
            XCTAssertEqual(log.message() as! String, message)
            XCTAssertEqual(log.userInfo!.keys.count, 2)
            XCTAssertEqual(log.userInfo!["some"] as! String, "info")
            XCTAssertEqual(log.userInfo!["test"] as! XCTestCase, self)
            processClosureCalled = true
            exp.fulfill()
        }

        logger.warning(message, userInfo: userinfo)

        waitForExpectations(timeout: 6) { error in
            guard let err = error else { return }
            XCTFail("Expectation timed out with error: \(String(describing: err))")
        }

        XCTAssertTrue(processClosureCalled)
    }

    func testErrorLevel() {
        logger = Tambo.default
        logger.removeAllStreams()
        let mockStream = StreamMock()
        mockStream.outputLevel = .verbose
        logger.add(stream: mockStream)
        let userinfo: TJSONType = ["some": "info", "test": self]
        let message = "ciccio"

        let exp = expectation(description: "Wait for the log to be processed")
        var processClosureCalled = false
        mockStream.processClosure = { log in
            XCTAssertEqual(log.level, .error)
            XCTAssertEqual(log.message() as! String, message)
            XCTAssertEqual(log.userInfo!.keys.count, 2)
            XCTAssertEqual(log.userInfo!["some"] as! String, "info")
            XCTAssertEqual(log.userInfo!["test"] as! XCTestCase, self)
            processClosureCalled = true
            exp.fulfill()
        }

        logger.error(message, userInfo: userinfo)

        waitForExpectations(timeout: 6) { error in
            guard let err = error else { return }
            XCTFail("Expectation timed out with error: \(String(describing: err))")
        }

        XCTAssertTrue(processClosureCalled)
    }

    func testXcodeConsoleInfoLevel() {
        logger = Tambo(identifier: "loggerIdentifier")
        let consoleStream = TConsoleStream(
            identifier: "consoleID",
            printMode: .print
        )
        consoleStream.isAsync = false

        logger.add(stream: consoleStream)
        DispatchQueue.concurrentPerform(iterations: 2) { _ in
            XCTAssertNoThrow(
                logger.info("", userInfo: ["some": 2, "test": self]), """
                Placing `self` in the userInfo dictionary should not throw:
                the conversation to JSON should convert `self` with the string
                description i.e. "-[TamboTests testOSLogInfoLevel]".
                """)
        }
    }
}
