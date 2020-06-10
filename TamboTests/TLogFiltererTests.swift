//
//  TStreamFilterableTests.swift
//  Tambo
//
//  Created by Massimo Donati on 8/17/18.
//

import XCTest
@testable import Tambo

class TLogFiltererTests: XCTestCase {
    var filterableClass: FilterableClassMock!
    let logMock = Log(loggerID: "test",
                       level: .info,
                       date: Date(),
                       message: { return "" },
                       condition: true,
                       threadName: "main",
                       functionName: "",
                       filePath: "nil",
                       lineNumber: 0,
                       context: ["hello": "world"])

    override func setUp() {
        filterableClass = FilterableClassMock()
    }

    override func tearDown() {
        filterableClass = nil
    }

    func testNoFilters() {
        let shouldIt = filterableClass.should(filterOut: logMock)
        XCTAssertFalse(shouldIt)
    }

    func testPositiveFilter() {
        filterableClass.filters.value.append { (log) -> Bool in
            log.loggerID == "test"
        }

        let shouldIt = filterableClass.should(filterOut: logMock)
        XCTAssertTrue(shouldIt)
    }

    func testNegativeFilter() {
        filterableClass.filters.value.append { (log) -> Bool in
            log.loggerID == "test message"
        }

        let shouldIt = filterableClass.should(filterOut: logMock)
        XCTAssertFalse(shouldIt)
    }

    func testMultipleFilters() {
        filterableClass.filters.value.append { (log) -> Bool in
            log.loggerID == "test message"
        }

        filterableClass.filters.value.append { (log) -> Bool in
            log.threadName == "main"
        }


        let shouldIt = filterableClass.should(filterOut: logMock)
        XCTAssertTrue(shouldIt, "the log message doesn't satisfy the first predicate")
    }

    func testHelperMethods() {
        let count = filterableClass.filters.value.count
        XCTAssertEqual(count, 0)

        filterableClass.addFilterOutClosure { (log) -> Bool in
            log.loggerID == "test message"
        }

        let count1 = filterableClass.filters.value.count
        XCTAssertEqual(count1, 1)

        filterableClass.removeFilters()
        let count0 = filterableClass.filters.value.count
        XCTAssertEqual(count0, 0)
    }
}

class FilterableClassMock: LogFilterer {
    public var filters: TAtomicWrite<[FilterClosure]> = TAtomicWrite(wrappedValue: [])
}
