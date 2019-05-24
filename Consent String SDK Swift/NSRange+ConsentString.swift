//
//  NSRange+ConsentString.swift
//  Consent String SDK Swift
//
//  Created by Alexander Edge on 22/05/2019.
//  Copyright © 2019 Guardian News & Media Ltd. All rights reserved.
//

import Foundation

extension NSRange {
    static let version = NSRange(location: 0, length: 6)
    static let created = NSRange(location: 6, length: 36)
    static let updated = NSRange(location: 42, length: 36)
    static let cmpIdentifier = NSRange(location: 78, length: 12)
    static let cmpVersion = NSRange(location: 90, length: 12)
    static let consentScreen = NSRange(location: 102, length: 6)
    static let consentLanguage = NSRange(location: 108, length: 12)
    static let vendorListVersion = NSRange(location: 120, length: 12)
    static let purposes = NSRange(location: 132, length: 24)
    static let maxVendorIdentifier = NSRange(location: 156, length: 16)
    static let encodingType = NSRange(location: 172, length: 1)
    static let defaultConsent = NSRange(location: 173, length: 1)
    static let numberOfEntries = NSRange(location: 174, length: 12)
}
