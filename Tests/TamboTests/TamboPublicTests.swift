//
//  TamboPublicTests.swift
//  
//
//  Created by Massimo Donati on 12/2/22.
//

import XCTest
import Tambo
import Combine

final class TamboPublicTests: XCTestCase {
    var cancellables: [AnyCancellable] = []
    var logger: Tambo!

    override func setUp() {
        cancellables = []
        logger = Tambo(identifier: UUID().uuidString).processing( .syncToCurrentThread)
    }

    func testPublicFormatterAPIWithFormatterObject() throws {
        // test all log levels
        let logger1 = Tambo(identifier: "")
            .processing( .syncToCurrentThread)
            .allowingLevels(.info, .error, .warning, .critical, .trace, .debug)
            .allowingLevels(.all)

        struct Formatter: TamboLogFormatter {
            func format(_ log: Event) -> String {
                return log.message()
            }
        }

        var logs: [String] = []
        logger1
            .formattedLogsPublisher(Formatter())
            .sink { logs.append($0) }
            .store(in: &cancellables)

        let message = UUID().uuidString
        logger1.info(message, context: ["non-relevant": "info"])
        let loggedMessage = try XCTUnwrap(logs.first)
        XCTAssertEqual(loggedMessage, message)
    }

    func testPublicFormatterAPIWithFormatterBlock() throws {
        var logs: [String] = []
        logger
            .formattedLogsPublisher({ $0.message() })
            .sink { logs.append($0) }
            .store(in: &cancellables)

        let message = UUID().uuidString
        logger.info(message, context: ["non-relevant": "info"])
        let loggedMessage = try XCTUnwrap(logs.first)
        XCTAssertEqual(loggedMessage, message)
    }

    func testPublicFormatterAPIWithDefaultStringFormatter() throws {
        var logs: [String] = []
        logger
            .stringFormattedLogsPublisher("M")
            .sink { logs.append($0) }
            .store(in: &cancellables)

        let message = UUID().uuidString
        logger.info(message, context: ["non-relevant": "info"])
        let loggedMessage = try XCTUnwrap(logs.first)
        XCTAssertEqual(loggedMessage, message)
    }

    func testPublicLoggingAPI() throws {
        var logs: [Event] = []
        logger.unformattedLogsPublisher
            .sink { logs.append($0) }
            .store(in: &cancellables)

        logger.info("something has happened")
        logger.trace("something has happened")
        logger.error("something has happened")
        logger.warning("something has happened")
        logger.debug("something has happened")
        logger.critical("something has happened")

        XCTAssertEqual(logs.count, 6)

        let _ = try XCTUnwrap(logs.filter({ $0.level == .info }))
        let _ = try XCTUnwrap(logs.filter({ $0.level == .trace }))
        let _ = try XCTUnwrap(logs.filter({ $0.level == .error }))
        let _ = try XCTUnwrap(logs.filter({ $0.level == .warning }))
        let _ = try XCTUnwrap(logs.filter({ $0.level == .debug }))
        let _ = try XCTUnwrap(logs.filter({ $0.level == .critical }))
    }
}
