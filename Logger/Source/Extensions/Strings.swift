//
//  LogUtilities.swift
//  Hubble
//
//  Created by Kyle Begeman on 1/26/18.
//  Copyright © 2018 Kyle Begeman. All rights reserved.
//

import UIKit

internal extension String {
    /// The last path component of the receiver.
    var lastPathComponent: String {
        return NSString(string: self).lastPathComponent
    }

    /// A new string made by deleting the extension from the receiver.
    var stringByDeletingPathExtension: String {
        return NSString(string: self).deletingPathExtension
    }
}
