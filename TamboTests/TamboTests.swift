//
//  TamboTests.swift
//  TamboTests
//
//  Created by Massimo Donati on 7/23/18.
//

import XCTest
@testable import Tambo

class TamboTests: XCTestCase {
    var logger: Tambo!
    var mockStream: StreamMock!

    override func setUp() {
        super.setUp()
        logger = Tambo(identifier: "test")
        logger.concurrentDispatcher = SyncConcurrentDispatcher()
        mockStream = StreamMock()
        logger.add(stream: mockStream)
    }
    
    override func tearDown() {
        logger = nil
        super.tearDown()
    }

    func testDefaultTambo() {
        mockStream.outputLevel = .trace
        let context: TJSONType = ["some": "info", "test": self]
        let message = "ciccio"
        var processClosureCalled = false
        mockStream.processClosure = { log in
            XCTAssertEqual(log.level, .info)
            XCTAssertEqual(log.message() as! String, message)
            XCTAssertEqual(log.context!.keys.count, 2)
            XCTAssertEqual(log.context!["some"] as! String, "info")
            XCTAssertEqual(log.context!["test"] as! XCTestCase, self)
            processClosureCalled = true
        }

        logger.info(message, context: context)

        XCTAssertTrue(processClosureCalled)
    }

    func testStreamNotEnabledForLevel() {
        XCTAssertTrue(Tambo.default === Tambo.default)
        mockStream.outputLevel = .info
        let userinfo: TJSONType = ["some": "info", "test": self]
        let message = "ciccio"

        var processClosureCalled = false
        mockStream.processClosure = { log in
            processClosureCalled = true
        }

        logger.trace(message, context: userinfo)

        XCTAssertFalse(processClosureCalled, """
            with an `info` outputLevel the stream should not procees a \
            verbose message
            """
        )
    }

    func testStreamSholdNotProcess() {
        mockStream.outputLevel = .trace
        logger.add(stream: mockStream)
        let userinfo: TJSONType = ["some": "info", "test": self]
        let message = "ciccio"

        mockStream.processClosure = { log in
            XCTFail("""
                with an `info` outputLevel the stream should not procees a \
                verbose message
                """)
        }
        var shouldFilterOutClosureCalled = false
        mockStream.shouldFilterOutClosure = { _ in
            shouldFilterOutClosureCalled = true
            return true
        }

        logger.trace(message, context: userinfo)

        XCTAssertTrue(shouldFilterOutClosureCalled)
    }

    func testVerboseLevel() {

        mockStream.outputLevel = .trace
        let userinfo: TJSONType = ["some": "info", "test": self]
        let message = "ciccio"
        var processClosureCalled = false
        mockStream.processClosure = { log in
            XCTAssertEqual(log.level, .trace)
            XCTAssertEqual(log.message() as! String, message)
            XCTAssertEqual(log.context!.keys.count, 2)
            XCTAssertEqual(log.context!["some"] as! String, "info")
            XCTAssertEqual(log.context!["test"] as! XCTestCase, self)
            processClosureCalled = true
        }

        logger.trace(message, context: userinfo)
        XCTAssertTrue(processClosureCalled)
    }

    func testDebugLevel() {
        mockStream.outputLevel = .trace
        let userinfo: TJSONType = ["some": "info", "test": self]
        let message = "ciccio"

        var processClosureCalled = false
        mockStream.processClosure = { log in
            XCTAssertEqual(log.level, .debug)
            XCTAssertEqual(log.message() as! String, message)
            XCTAssertEqual(log.context!.keys.count, 2)
            XCTAssertEqual(log.context!["some"] as! String, "info")
            XCTAssertEqual(log.context!["test"] as! XCTestCase, self)
            processClosureCalled = true
        }

        logger.debug(message, context: userinfo)
        XCTAssertTrue(processClosureCalled)
    }

    func testInfoLevel() {
        mockStream.outputLevel = .trace
        let userinfo: TJSONType = ["some": "info", "test": self]
        let message = "ciccio"

        var processClosureCalled = false
        mockStream.processClosure = { log in
            XCTAssertEqual(log.level, .info)
            XCTAssertEqual(log.message() as! String, message)
            XCTAssertEqual(log.context!.keys.count, 2)
            XCTAssertEqual(log.context!["some"] as! String, "info")
            XCTAssertEqual(log.context!["test"] as! XCTestCase, self)
            processClosureCalled = true
        }

        logger.info(message, context: userinfo)
        XCTAssertTrue(processClosureCalled)
    }

    func testWarningLevel() {

        mockStream.outputLevel = .trace
        logger.add(stream: mockStream)
        let userinfo: TJSONType = ["some": "info", "test": self]
        let message = "ciccio"

        var processClosureCalled = false
        mockStream.processClosure = { log in
            XCTAssertEqual(log.level, .warning)
            XCTAssertEqual(log.message() as! String, message)
            XCTAssertEqual(log.context!.keys.count, 2)
            XCTAssertEqual(log.context!["some"] as! String, "info")
            XCTAssertEqual(log.context!["test"] as! XCTestCase, self)
            processClosureCalled = true
        }

        logger.warning(message, context: userinfo)
        XCTAssertTrue(processClosureCalled)
    }

    func testErrorLevel() {
        mockStream.outputLevel = .trace
        let userinfo: TJSONType = ["some": "info", "test": self]
        let message = "ciccio"

        var processClosureCalled = false
        mockStream.processClosure = { log in
            XCTAssertEqual(log.level, .error)
            XCTAssertEqual(log.message() as! String, message)
            XCTAssertEqual(log.context!.keys.count, 2)
            XCTAssertEqual(log.context!["some"] as! String, "info")
            XCTAssertEqual(log.context!["test"] as! XCTestCase, self)
            processClosureCalled = true
        }

        logger.error(message, context: userinfo)
        XCTAssertTrue(processClosureCalled)
    }

    func testXcodeConsoleInfoLevel() {
        logger = Tambo(identifier: "loggerIdentifier")
        let consoleStream = ConsoleStream(
            identifier: "consoleID",
            printMode: .print
        )
        consoleStream.isAsync = false

        logger.add(stream: consoleStream)
        DispatchQueue.concurrentPerform(iterations: 2) { _ in
            XCTAssertNoThrow(
                logger.info("", context: ["some": 2, "test": self]), """
                Placing `self` in the userInfo dictionary should not throw:
                the conversation to JSON should convert `self` with the string
                description i.e. "-[TamboTests testOSLogInfoLevel]".
                """)
        }
    }

    func testLogWithoutCondition() {
        let uuid = UUID().uuidString
        var processClosureCalled = false
        mockStream.processClosure = { log in
            processClosureCalled = true
            XCTAssertEqual(log.message() as! String, uuid)
        }

        logger.error(uuid, condition: nil)

        XCTAssertTrue(processClosureCalled)
    }

    func testLogWithTrueCondition() {
        let uuid = UUID().uuidString
        var processClosureCalled = false
        mockStream.processClosure = { log in
            processClosureCalled = true
            XCTAssertEqual(log.message() as! String, uuid)
        }

        logger.error(uuid, condition: true)

        XCTAssertTrue(processClosureCalled)
    }

    func testLogWithFalseCondition() {
        let uuid = UUID().uuidString
        var processClosureCalled = false
        mockStream.processClosure = { _ in
            processClosureCalled = true
        }

        logger.error(uuid, condition: false)

        XCTAssertFalse(processClosureCalled)
    }
}
