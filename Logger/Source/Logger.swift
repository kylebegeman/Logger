//
//  Logger.swift
//  Hubble
//
//  Created by Kyle Begeman on 1/26/18.
//  Copyright © 2018 Kyle Begeman. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

/******************************************************************************************
 Copied from https://github.com/delba/Log
 Stripped and updated to Swift 4
 *******************************************************************************************/

import UIKit

public enum Level {
    case debug, info, warning, error

    var description: String {
        return String(describing: self).uppercased()
    }

    var display: String {
        switch self {
        case .debug: return "💙 - \(self.description)"
        case .info: return "💜 - \(self.description)"
        case .warning: return "💛 - \(self.description)"
        case .error: return "❤️ - \(self.description)"
        }
    }
}

extension Level: Comparable {}

public func == (x: Level, y: Level) -> Bool {
    return x.hashValue == y.hashValue
}

public func < (x: Level, y: Level) -> Bool {
    return x.hashValue < y.hashValue
}

open class Logger {
    /// The logger state.
    public var enabled: Bool = true

    /// The logger formatter.
    public var formatter: Formatter {
        didSet { formatter.logger = self }
    }

    /// The minimum level of severity.
    public var minLevel: Level

    /// The logger format.
    public var format: String {
        return formatter.description
    }

    /// The queue used for logging.
    private let queue = DispatchQueue(label: "logger.log")

    /// Creates and returns a new logger.
    ///
    /// - Parameters:
    ///   - formatter: The formatter.
    ///   - minLevel: The minimum level of severity.
    public init(formatter: Formatter = .default, minLevel: Level = .debug) {
        self.formatter = formatter
        self.minLevel = minLevel

        formatter.logger = self
    }

    /// Logs a message with a debug severity level.
    ///
    /// - Parameters:
    ///   - items: The items to log.
    ///   - separator: The separator between the items.
    ///   - terminator: The terminator of the log message.
    ///   - file: The file in which the log happens.
    ///   - line: The line at which the log happens.
    ///   - column: The column at which the log happens.
    ///   - function: The function in which the log happens.
    open func debug(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.debug, items, separator, terminator, file, line, column, function)
    }

    /// Logs a message with an info severity level.
    ///
    /// - Parameters:
    ///   - items: The items to log.
    ///   - separator: The separator between the items.
    ///   - terminator: The terminator of the log message.
    ///   - file: The file in which the log happens.
    ///   - line: The line at which the log happens.
    ///   - column: The column at which the log happens.
    ///   - function: The function in which the log happens.
    open func info(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.info, items, separator, terminator, file, line, column, function)
    }

    /// Logs a message with a warning severity level.
    ///
    /// - Parameters:
    ///   - items: The items to log.
    ///   - separator: The separator between the items.
    ///   - terminator: The terminator of the log message.
    ///   - file: The file in which the log happens.
    ///   - line: The line at which the log happens.
    ///   - column: The column at which the log happens.
    ///   - function: The function in which the log happens.
    open func warning(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.warning, items, separator, terminator, file, line, column, function)
    }

    /// Logs a message with an error severity level.
    ///
    /// - Parameters:
    ///   - items: The items to log.
    ///   - separator: The separator between the items.
    ///   - terminator: The terminator of the log message.
    ///   - file: The file in which the log happens.
    ///   - line: The line at which the log happens.
    ///   - column: The column at which the log happens.
    ///   - function: The function in which the log happens.
    open func error(_ items: Any..., separator: String = " ", terminator: String = "\n", file: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
        log(.error, items, separator, terminator, file, line, column, function)
    }

    /// Logs a message
    ///
    /// - Parameters:
    ///   - items: The items to log.
    ///   - separator: The separator between the items.
    ///   - terminator: The terminator of the log message.
    ///   - file: The file in which the log happens.
    ///   - line: The line at which the log happens.
    ///   - column: The column at which the log happens.
    ///   - function: The function in which the log happens.
    private func log(_ level: Level, _ items: [Any], _ separator: String, _ terminator: String, _ file: String, _ line: Int, _ column: Int, _ function: String) {
        guard enabled && level >= minLevel else { return }

        let date = Date()

        let result = formatter.format(
            level: level,
            items: items,
            separator: separator,
            terminator: terminator,
            file: file,
            line: line,
            column: column,
            function: function,
            date: date
        )

        queue.async {
            Swift.print(result, separator: separator, terminator: terminator)
        }
    }
}
