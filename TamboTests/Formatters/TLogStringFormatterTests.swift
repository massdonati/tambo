//
//  TLogStringFormatterTests.swift
//  Tambo
//
//  Created by Massimo Donati on 8/4/18.
//

import XCTest
@testable import Tambo

class TLogStringFormatterTests: XCTestCase {
    var formatter: TLogStringFormatter!
    override func setUp() {
        super.setUp()
        formatter = TLogStringFormatter()
    }

    override func tearDown() {
        formatter = nil
        super.tearDown()
    }

    func testDefaultFormatString() {
        XCTAssertEqual(formatter.logFormat, "[D] [L] T S F.f:# - M\nI")
    }

    func testDefaultDateFormatterFormat() {
        XCTAssertEqual(formatter.dateFormatter.dateFormat, "HH:mm:ss.SSS")
    }

    func testLogFormatDoesntChange() {
        let formatter = TLogStringFormatter()
        let format = formatter.logFormat
        let log = TLog(loggerID: "id",
                       level: .info,
                       date: Date(),
                       message: { return ""},
                       threadName: "main", functionName: "ciccio",
                       filePath: "/proj/Ciccio.swift",
                       lineNumber: 12,
                       userInfo: ["ciccio": "ciccio"])

        _ = formatter.format(log)

        XCTAssertEqual(format, formatter.logFormat)
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
                       filePath: "nil",
                       lineNumber: 0,
                       userInfo: nil)
        let stringDate = formatter.dateFormatter.string(from: date)
        let outString = formatter.format(log)
        XCTAssertEqual(stringDate, outString)

        // test additional text

        formatter.logFormat = "[D]"
        let outStringTwo = formatter.format(log)
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
                       filePath: "nil",
                       lineNumber: 0,
                       userInfo: nil)

        let outString = formatter.format(log)
        XCTAssertEqual(loggerID, outString)

        // test additional text

        formatter.logFormat = "[L]"
        let outStringTwo = formatter.format(log)
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
                       filePath: "nil",
                       lineNumber: 0,
                       userInfo: nil)

        let outString = formatter.format(log)
        XCTAssertEqual(threadName, outString)

        // test additional text

        formatter.logFormat = "[T]"
        let outStringTwo = formatter.format(log)
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
                           filePath: "nil",
                           lineNumber: 0,
                           userInfo: nil)

            let outString = formatter.format(log)
            XCTAssertEqual(level.name, outString)

            // test additional text

            formatter.logFormat = "[l]"
            let outStringTwo = formatter.format(log)
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
                           filePath: "nil",
                           lineNumber: 0,
                           userInfo: nil)

            let outString = formatter.format(log)
            XCTAssertEqual(level.symbol, outString)

            // test additional text

            formatter.logFormat = "[S]"
            let outStringTwo = formatter.format(log)
            XCTAssertEqual("[\(level.symbol)]", outStringTwo)
        }
    }

    func testFileNameOnly() {
        let fileName = "TamboViewController"
        let filePath = "/proj/\(fileName).swift"
        formatter.logFormat = "F"

        let log = TLog(loggerID: "test",
                       level: .info,
                       date: Date(),
                       message: { return "" },
                       threadName: "main",
                       functionName: "",
                       filePath: filePath,
                       lineNumber: 0,
                       userInfo: nil)

        let outString = formatter.format(log)
        XCTAssertEqual(fileName, outString)

        // test additional text

        formatter.logFormat = "[F]"
        let outStringTwo = formatter.format(log)
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
                       filePath: "",
                       lineNumber: 0,
                       userInfo: nil)

        let outString = formatter.format(log)
        XCTAssertEqual(functionName, outString)

        // test additional text

        formatter.logFormat = "[f]"
        let outStringTwo = formatter.format(log)
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
                       filePath: "",
                       lineNumber: lineNumber,
                       userInfo: nil)

        let outString = formatter.format(log)
        XCTAssertEqual("\(lineNumber)", outString)

        // test additional text

        formatter.logFormat = "[#]"
        let outStringTwo = formatter.format(log)
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
                       filePath: "nil",
                       lineNumber: 0,
                       userInfo: nil)

        let outString = formatter.format(log)
        XCTAssertEqual(messageText, outString)

        // test additional text

        formatter.logFormat = "[M]"
        let outStringTwo = formatter.format(log)
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
                       filePath: "nil",
                       lineNumber: 0,
                       userInfo: userInfo)

        let outString = formatter.format(log)
        XCTAssertEqual(log.userInfoJSONString, outString)

        // test additional text

        formatter.logFormat = "[I]"
        let outStringTwo = formatter.format(log)
        XCTAssertEqual("[\(log.userInfoJSONString!)]", outStringTwo)
    }
}
