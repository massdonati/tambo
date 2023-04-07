import XCTest
import Combine
@testable import Tambo

final class TamboTests: XCTestCase {
    var cancellables: [AnyCancellable] = []
    func testIdentifier() throws {
        let identifier = UUID().uuidString
        XCTAssertEqual(Tambo(identifier: identifier).identifier, identifier)
    }

    func testSubscription() throws {
        let logger = Tambo(identifier: "abc")
            .processing(.syncToCurrentThread)
        logger
            .stringFormattedLogsPublisher()
            .printLogs()
            .store(in: &cancellables)

        logger.info("one", context: ["ciccio" : "mao"])
        logger.info("one")
        logger.info("one")
        logger.info("one")
    }

    func testLevels() throws {
        let logger = Tambo(identifier: "abc")
            .processing(.syncToCurrentThread)
            .allowingLevels(.error)
        var logs: [String] = []
        logger
            .stringFormattedLogsPublisher()
            .sink { message in
                logs.append(message)
            }.store(in: &cancellables)

        logger.info("one", context: ["ciccio" : "mao"])
        logger.info("one")
        logger.info("one")
        logger.info("one")

        XCTAssertTrue(logs.isEmpty)
        logger.error("some error")
        XCTAssertFalse(logs.isEmpty)
    }

    func testMethods() throws {
        let logger = Tambo(identifier: "abc")
            .processing(.syncToCurrentThread)
            .allowingLevels(.all)

        var logs: [String] = []
        let cancellable = logger
            .formattedLogsPublisher({ $0.id.uuidString })
            .sink { message in
                logs.append(message)
            }

        logger.info("one", context: ["ciccio" : "mao"])
        logger.info("two")
        logger.info("three")
        logger.info("four")

        XCTAssertEqual(logs.count, 4)
        logger.error("some error")
        XCTAssertEqual(logs.count, 5)
        print(cancellable)
    }

    func testMethodsWithLevels() throws {
        let logger = Tambo(identifier: "abc")
            .processing(.syncToCurrentThread)
            .allowingLevels([.error])

        var logs: [String] = []
        let cancellable = logger
            .formattedLogsPublisher({ String(describing: $0.message) })
            .sink { message in
                logs.append(message)
            }

        logger.info("one", context: ["ciccio" : "mao"])
        logger.info("two")
        logger.info("three")
        logger.info("four")

        XCTAssertEqual(logs.count, 0)
        logger.error("some error")
        XCTAssertEqual(logs.count, 1)
        print(cancellable)
    }
}
