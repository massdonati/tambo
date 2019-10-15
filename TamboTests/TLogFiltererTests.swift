//
//  TStreamFilterableTests.swift
//  Tambo
//
//  Created by Massimo Donati on 8/17/18.
//

import XCTest
@testable import Tambo

class TLogFiltererTests: XCTestCase {
    var filterableClass: FilterableClass!
    let logMock = TLog(loggerID: "test",
                       level: .info,
                       date: Date(),
                       message: { return "" },
                       threadName: "main",
                       functionName: "",
                       filePath: "nil",
                       lineNumber: 0,
                       context: ["hello": "world"])

    override func setUp() {
        filterableClass = FilterableClass()
    }

    override func tearDown() {
        filterableClass = nil
    }

    func testNoFilters() {
        let shouldIt = filterableClass.should(filterOut: logMock)
        XCTAssertFalse(shouldIt)
    }

    func testPositiveFilter() {
        filterableClass.filters.write { filters in
            filters.append { (log) -> Bool in
                log.loggerID == "test"
            }
        }
        let shouldIt = filterableClass.should(filterOut: logMock)
        XCTAssertTrue(shouldIt)
    }

    func testNegativeFilter() {
        filterableClass.filters.write { filters in
            filters.append { (log) -> Bool in
                log.loggerID == "test message"
            }
        }
        let shouldIt = filterableClass.should(filterOut: logMock)
        XCTAssertFalse(shouldIt)
    }

    func testMultipleFilters() {
        filterableClass.filters.write { filters in
            filters.append { (log) -> Bool in
                log.loggerID == "test message"
            }
        }

        filterableClass.filters.write { filters in
            filters.append { (log) -> Bool in
                log.threadName == "main"
            }
        }

        let shouldIt = filterableClass.should(filterOut: logMock)
        XCTAssertTrue(shouldIt, "the log message doesn't satisfy the first predicate")
    }

    func testHelperMethods() {
        let count = filterableClass.filters.read { $0.count }
        XCTAssertEqual(count, 0)

        filterableClass.addFilterOutClosure { (log) -> Bool in
            log.loggerID == "test message"
        }

        let count1 = filterableClass.filters.read { $0.count }
        XCTAssertEqual(count1, 1)

        filterableClass.removeFilters()
        let count0 = filterableClass.filters.read { $0.count }
        XCTAssertEqual(count0, 0)
    }
}

class FilterableClass: TLogFilterer {
    var filters = TThreadProtector<[TFilterClosure]>([])
}
