import XCTest
import Combine
@testable import Tambo

final class TamboTests: XCTestCase {
    var cancellable: AnyCancellable?
    func testIdentifier() throws {
        let identifier = UUID().uuidString
        XCTAssertEqual(TamboLogger(identifier: identifier).identifier, identifier)
    }

    func testSubscription() throws {
        let logger = TamboLogger(identifier: "abc")
        cancellable = logger
            .logStreamPublisher
            .formatWithDefaultStringFormatter()
            .logToConsole().sink { _ in }

        logger.info("one", context: ["ciccio" : .string("mao")])
        logger.info("one")
        logger.info("one")
        logger.info("one")
    }
}
