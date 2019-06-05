//
//  Purpose.swift
//  Consent String SDK Swift
//
//  Created by Alexander Edge on 17/05/2019.
//  Copyright © 2019 Guardian News & Media Ltd. All rights reserved.
//

import Foundation

/// Purposes are listed in the global Vendor List. Purpose #1 maps to the first (most significant) bit, purpose #24 maps to the last (least significant) bit.
public struct Purposes: OptionSet {

    public static let storageAndAccess = Purposes(rawValue: 1 << 23)
    public static let personalization = Purposes(rawValue: 1 << 22)
    public static let adSelection = Purposes(rawValue: 1 << 21)
    public static let contentDelivery = Purposes(rawValue: 1 << 20)
    public static let measurement = Purposes(rawValue: 1 << 19)
    public static let all: Purposes = [.storageAndAccess, .personalization, .adSelection, .contentDelivery, .measurement]

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}
