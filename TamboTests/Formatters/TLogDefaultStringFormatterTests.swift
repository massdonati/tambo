//
//  TLogDefaultStringFormatterTests.swift
//  Tambo
//
//  Created by Massimo Donati on 8/4/18.
//

import XCTest
@testable import Tambo

class TLogDefaultStringFormatterTests: XCTestCase {
    var formatter: TLogDefaultStringFormatter!
    override func setUp() {
        formatter = TLogDefaultStringFormatter()
    }

    override func tearDown() {
        formatter = nil
    }

    func testDefaultFormatString() {
        XCTAssertEqual(formatter.logFormat, "[D] [L] T S F.f:# - M\nI")
    }

    func testDefaultDateFormatterFormat() {
        XCTAssertEqual(formatter.dateFormatter.dateFormat, "HH:mm:ss.SSS")
    }

    func testLogFormatDoesntChange() {
        let formatter = TLogDefaultStringFormatter()
        let format = formatter.logFormat
        let log = TLog(loggerID: "id",
                       level: .info,
                       date: Date(),
                       message: { return ""},
                       threadName: "main", functionName: "ciccio",
                       fileName: "Ciccio.swift",
                       lineNumber: 12,
                       userInfo: ["ciccio": "ciccio"])

        _ = formatter.string(for: log)

        XCTAssertEqual(format, formatter.logFormat)
    }

    func testFormatFunction() {
        let formatter = TLogDefaultStringFormatter()
        let log = TLog(loggerID: "id",
                       level: .info,
                       date: Date(),
                       message: { return ""},
                       threadName: "main", functionName: "ciccio",
                       fileName: "Ciccio.swift",
                       lineNumber: 12,
                       userInfo: ["ciccio": "ciccio"])

        let expectedString = formatter.string(for: log)
        XCTAssertTrue(formatter.format(log) is String)
        let generatedString = formatter.format(log) as! String
        XCTAssertEqual(generatedString, expectedString)
    }

    func testDateOnly() {
        formatter.logFormat = "D"
        let date = Date()
        let log = TLog(loggerID: "test",
                       level: .debug,
                       date: date,
                       message: { return "" },
                       threadName: "",
                       functionName: "",
                       fileName: "nil",
                       lineNumber: 0,
                       userInfo: nil)
        let stringDate = formatter.dateFormatter.string(from: date)
        let outString = formatter.string(for: log)
        XCTAssertEqual(stringDate, outString)

        // test additional text

        formatter.logFormat = "[D]"
        let outStringTwo = formatter.string(for: log)
        XCTAssertEqual("[\(stringDate)]", outStringTwo)
    }

    func testLoggerNameOnly() {
        formatter.logFormat = "L"
        let loggerID = "com.tambo.logger"
        let log = TLog(loggerID: loggerID,
                       level: .debug,
                       date: Date(),
                       message: { return "" },
                       threadName: "",
                       functionName: "",
                       fileName: "nil",
                       lineNumber: 0,
                       userInfo: nil)

        let outString = formatter.string(for: log)
        XCTAssertEqual(loggerID, outString)

        // test additional text

        formatter.logFormat = "[L]"
        let outStringTwo = formatter.string(for: log)
        XCTAssertEqual("[\(loggerID)]", outStringTwo)
    }

    func testThreadNameOnly() {
        formatter.logFormat = "T"
        let threadName = "main"
        let log = TLog(loggerID: "test",
                       level: .debug,
                       date: Date(),
                       message: { return "" },
                       threadName: threadName,
                       functionName: "",
                       fileName: "nil",
                       lineNumber: 0,
                       userInfo: nil)

        let outString = formatter.string(for: log)
        XCTAssertEqual(threadName, outString)

        // test additional text

        formatter.logFormat = "[T]"
        let outStringTwo = formatter.string(for: log)
        XCTAssertEqual("[\(threadName)]", outStringTwo)
    }

    func testLevelNameOnly() {
        let levels: [TLogLevel] = [.info, .debug, .error, .verbose, .warning]
        levels.forEach { level in
            formatter.logFormat = "l"

            let log = TLog(loggerID: "test",
                           level: level,
                           date: Date(),
                           message: { return "" },
                           threadName: "main",
                           functionName: "",
                           fileName: "nil",
                           lineNumber: 0,
                           userInfo: nil)

            let outString = formatter.string(for: log)
            XCTAssertEqual(level.name, outString)

            // test additional text

            formatter.logFormat = "[l]"
            let outStringTwo = formatter.string(for: log)
            XCTAssertEqual("[\(level.name)]", outStringTwo)
        }
    }

    func testLevelSymbolOnly() {
        let levels: [TLogLevel] = [.info, .debug, .error, .verbose, .warning]
        levels.forEach { level in
            formatter.logFormat = "S"

            let log = TLog(loggerID: "test",
                           level: level,
                           date: Date(),
                           message: { return "" },
                           threadName: "main",
                           functionName: "",
                           fileName: "nil",
                           lineNumber: 0,
                           userInfo: nil)

            let outString = formatter.string(for: log)
            XCTAssertEqual(level.symbol, outString)

            // test additional text

            formatter.logFormat = "[S]"
            let outStringTwo = formatter.string(for: log)
            XCTAssertEqual("[\(level.symbol)]", outStringTwo)
        }
    }

    func testFileNameOnly() {
        let fileName = "TamboViewController"
        formatter.logFormat = "F"

        let log = TLog(loggerID: "test",
                       level: .info,
                       date: Date(),
                       message: { return "" },
                       threadName: "main",
                       functionName: "",
                       fileName: fileName,
                       lineNumber: 0,
                       userInfo: nil)

        let outString = formatter.string(for: log)
        XCTAssertEqual(fileName, outString)

        // test additional text

        formatter.logFormat = "[F]"
        let outStringTwo = formatter.string(for: log)
        XCTAssertEqual("[\(fileName)]", outStringTwo)
    }

    func testFunctionNameOnly() {
        let functionName = "viewDidLoad()"
        formatter.logFormat = "f"

        let log = TLog(loggerID: "test",
                       level: .info,
                       date: Date(),
                       message: { return "" },
                       threadName: "main",
                       functionName: functionName,
                       fileName: "",
                       lineNumber: 0,
                       userInfo: nil)

        let outString = formatter.string(for: log)
        XCTAssertEqual(functionName, outString)

        // test additional text

        formatter.logFormat = "[f]"
        let outStringTwo = formatter.string(for: log)
        XCTAssertEqual("[\(functionName)]", outStringTwo)
    }

    func testLineNumberOnly() {
        let lineNumber = 24
        formatter.logFormat = "#"

        let log = TLog(loggerID: "test",
                       level: .info,
                       date: Date(),
                       message: { return "" },
                       threadName: "main",
                       functionName: "",
                       fileName: "",
                       lineNumber: lineNumber,
                       userInfo: nil)

        let outString = formatter.string(for: log)
        XCTAssertEqual("\(lineNumber)", outString)

        // test additional text

        formatter.logFormat = "[#]"
        let outStringTwo = formatter.string(for: log)
        XCTAssertEqual("[\(lineNumber)]", outStringTwo)
    }

    func testMessageOnly() {
        let messageText = "some info message"
        formatter.logFormat = "M"

        let log = TLog(loggerID: "test",
                       level: .info,
                       date: Date(),
                       message: { return messageText },
                       threadName: "main",
                       functionName: "",
                       fileName: "nil",
                       lineNumber: 0,
                       userInfo: nil)

        let outString = formatter.string(for: log)
        XCTAssertEqual(messageText, outString)

        // test additional text

        formatter.logFormat = "[M]"
        let outStringTwo = formatter.string(for: log)
        XCTAssertEqual("[\(messageText)]", outStringTwo)
    }

    func testUserInfoOnly() {
        let userInfo = ["one": 1]
        formatter.logFormat = "I"

        let log = TLog(loggerID: "test",
                       level: .info,
                       date: Date(),
                       message: { return userInfo },
                       threadName: "main",
                       functionName: "",
                       fileName: "nil",
                       lineNumber: 0,
                       userInfo: userInfo)

        let outString = formatter.string(for: log)
        XCTAssertEqual(log.userInfoJSONString, outString)

        // test additional text

        formatter.logFormat = "[I]"
        let outStringTwo = formatter.string(for: log)
        XCTAssertEqual("[\(log.userInfoJSONString!)]", outStringTwo)
    }
}
