//
//  Formatter.swift
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

import UIKit

public enum Component {
    case date(String)
    case message
    case level
    case file(fullPath: Bool, fileExtension: Bool)
    case line
    case column
    case function
    case location
    case block(() -> Any?)
}

public class Formatters {}

public class Formatter: Formatters {
    /// The formatter format.
    private var format: String

    /// The formatter components.
    private var components: [Component]

    /// The date formatter.
    fileprivate let dateFormatter = DateFormatter()

    /// The formatter logger.
    internal weak var logger: Logger!

    /// The formatter textual representation.
    internal var description: String {
        return String(format: format, arguments: components.map { (component: Component) -> CVarArg in
            return String(describing: component).uppercased()
        })
    }

    /// Creates and returns a new formatter with the specified format and components.
    ///
    /// - Parameters:
    ///   - format: The formatter format.
    ///   - components: The formatter components.
    public convenience init(_ format: String, _ components: Component...) {
        self.init(format, components)
    }

    /// Creates and returns a new formatter with the specified format and components.
    ///
    /// - Parameters:
    ///   - format: The formatter format.
    ///   - components: The formatter components.
    public init(_ format: String, _ components: [Component]) {
        self.format = format
        self.components = components
    }

    /// Formats a string with the formatter format and components.
    ///
    /// - Parameters:
    ///   - level: The severity level.
    ///   - items: The items to format.
    ///   - separator: The separator between the items.
    ///   - terminator: The terminator of the formatted string.
    ///   - file: The log file path.
    ///   - line: The log line number.
    ///   - column: The log column number.
    ///   - function: The log function.
    ///   - date: The log date.
    /// - Returns: A formatted string.
    internal func format(level: Level, items: [Any], separator: String, terminator: String, file: String, line: Int, column: Int, function: String, date: Date) -> String {
        let arguments = components.map { (component: Component) -> CVarArg in
            switch component {
            case .date(let dateFormat): return format(date: date, dateFormat: dateFormat)
            case .file(let fullPath, let fileExtension): return format(file: file, fullPath: fullPath, fileExtension: fileExtension)
            case .function: return String(function)
            case .line: return String(line)
            case .column: return String(column)
            case .level: return format(level: level)
            case .message: return items.map({ String(describing: $0) }).joined(separator: separator)
            case .location: return format(file: file, line: line)
            case .block(let block): return block().flatMap({ String(describing: $0) }) ?? ""
            }
        }

        return String(format: format, arguments: arguments) + terminator
    }
}

private extension Formatter {
    /// Formats a date with the specified date format.
    ///
    /// - Parameters:
    ///   - date: The date.
    ///   - dateFormat: The date format.
    /// - Returns: A formatted date.
    func format(date: Date, dateFormat: String) -> String {
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: date)
    }

    /// Formats a file path with the specified parameters.
    ///
    /// - Parameters:
    ///   - file: The file path.
    ///   - fullPath: Whether the full path should be included.
    ///   - fileExtension: Whether the file extension should be included.
    /// - Returns: A formatted file path.
    func format(file: String, fullPath: Bool, fileExtension: Bool) -> String {
        var file = file

        if !fullPath { file = file.lastPathComponent }
        if !fileExtension { file = file.stringByDeletingPathExtension }

        return file
    }

    /// Formats a Location component with a specified file path and line number.
    ///
    /// - Parameters:
    ///   - file: The file path.
    ///   - line: The line number.
    /// - Returns: A formatted Location component.
    func format(file: String, line: Int) -> String {
        return [
            format(file: file, fullPath: false, fileExtension: true),
            String(line)
            ].joined(separator: ":")
    }
    /// Formats a Level component.
    ///
    /// - Parameter level: The Level component.
    /// - Returns: A formatted Level component.
    func format(level: Level) -> String {
        return level.display
    }
}
