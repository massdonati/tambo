import XCTest
import Combine
@testable import Tambo

final class TamboTests: XCTestCase {
    var cancellable: AnyCancellable?
    func testIdentifier() throws {
        let identifier = UUID().uuidString
        XCTAssertEqual(Tambo(identifier: identifier).identifier, identifier)
    }

    func testSubscription() throws {
        let logger = Tambo(identifier: "abc")
        logger
            .logsPublisher
            .formatToString()
            .logToConsole()

        logger.info("one", context: ["ciccio" : .string("mao")])
        logger.info("one")
        logger.info("one")
        logger.info("one")
    }

    func testLevels() throws {
        let logger = Tambo(identifier: "abc")
            .allowLevels([.error])
        var logs: [String] = []
        logger
            .logsPublisher
            .formatToString()
            .filter({
                logs.append($0)
                return true
            })
            .logToConsole()

        logger.info("one", context: ["ciccio" : .string("mao")])
        logger.info("one")
        logger.info("one")
        logger.info("one")

        XCTAssertTrue(logs.isEmpty)
        logger.error("some error")
        XCTAssertFalse(logs.isEmpty)
    }
}
