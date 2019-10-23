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
        XCTAssertEqual(formatter.logFormat, "[D] [L] T S F:# f - M\nC")
        let format = "some string format"
        formatter = TLogStringFormatter(with: format)
        XCTAssertEqual(formatter.logFormat, format)
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
                       condition: true,
                       threadName: "main",
                       functionName: "ciccio",
                       filePath: "/proj/Ciccio.swift",
                       lineNumber: 12,
                       context: ["ciccio": "ciccio"])

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
                       condition: true,
                       threadName: "",
                       functionName: "",
                       filePath: "nil",
                       lineNumber: 0,
                       context: nil)
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
                       condition: true,
                       threadName: "",
                       functionName: "",
                       filePath: "nil",
                       lineNumber: 0,
                       context: nil)

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
                       condition: true,
                       threadName: threadName,
                       functionName: "",
                       filePath: "nil",
                       lineNumber: 0,
                       context: nil)

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
                           condition: true,
                           threadName: "main",
                           functionName: "",
                           filePath: "nil",
                           lineNumber: 0,
                           context: nil)

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
                           condition: true,
                           threadName: "main",
                           functionName: "",
                           filePath: "nil",
                           lineNumber: 0,
                           context: nil)

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
                       condition: true,
                       threadName: "main",
                       functionName: "",
                       filePath: filePath,
                       lineNumber: 0,
                       context: nil)

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
                       condition: true,
                       threadName: "main",
                       functionName: functionName,
                       filePath: "",
                       lineNumber: 0,
                       context: nil)

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
                       condition: true,
                       threadName: "main",
                       functionName: "",
                       filePath: "",
                       lineNumber: lineNumber,
                       context: nil)

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
                       condition: true,
                       threadName: "main",
                       functionName: "",
                       filePath: "nil",
                       lineNumber: 0,
                       context: nil)

        let outString = formatter.format(log)
        XCTAssertEqual(messageText, outString)

        // test additional text

        formatter.logFormat = "[M]"
        let outStringTwo = formatter.format(log)
        XCTAssertEqual("[\(messageText)]", outStringTwo)
    }

    func testUserInfoOnly() {
        let context = ["one": 1]
        formatter.logFormat = "C"

        let log = TLog(loggerID: "test",
                       level: .info,
                       date: Date(),
                       message: { return context },
                       condition: true,
                       threadName: "main",
                       functionName: "",
                       filePath: "nil",
                       lineNumber: 0,
                       context: context)

        let outString = formatter.format(log)
        XCTAssertEqual(log.contextJSONString, outString)

        // test additional text

        formatter.logFormat = "[C]"
        let outStringTwo = formatter.format(log)
        XCTAssertEqual("[\(log.contextJSONString!)]", outStringTwo)
    }
}
