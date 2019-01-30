//
//  Formatters.swift
//  Hubble
//
//  Created by Kyle Begeman on 1/26/18.
//  Copyright © 2018 Kyle Begeman. All rights reserved.
//

import UIKit

public extension Formatters {
    public static let `default` = Formatter("[%@] %@ %@: %@", [
        .date("yyyy-MM-dd HH:mm:ss.SSS"),
        .location,
        .level,
        .message
    ])

    public static let minimal = Formatter("%@ %@: %@", [
        .location,
        .level,
        .message
    ])

    public static let detailed = Formatter("[%@] %@.%@:%@ %@: %@", [
        .date("yyyy-MM-dd HH:mm:ss.SSS"),
        .file(fullPath: false, fileExtension: false),
        .function,
        .line,
        .level,
        .message
    ])
}
