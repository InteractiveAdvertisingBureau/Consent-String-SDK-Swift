//
//  ConsentStringBuilding.swift
//  Consent String SDK Swift
//
//  Created by Alexander Edge on 30/05/2019.
//  Copyright © 2019 Guardian News & Media Ltd. All rights reserved.
//

import Foundation

public protocol ConsentStringBuilding {
    func build(created: Date, updated: Date, cmpId: Int, cmpVersion: Int, consentScreenId: Int, consentLanguage: String, allowedPurposes: Purposes, vendorListVersion: Int, maxVendorId: VendorIdentifier, defaultConsent: Bool, allowedVendorIds: Set<VendorIdentifier>) throws -> String
    func encode(purposeBitFieldForPurposes purposes: Purposes) -> String
    func encode(vendorBitFieldForVendors vendors: Set<VendorIdentifier>, maxVendorId: VendorIdentifier) -> String
}

public extension ConsentStringBuilding {
    func build(cmpId: Int, cmpVersion: Int, consentScreenId: Int, consentLanguage: String, allowedPurposes: Purposes, vendorListVersion: Int, maxVendorId: VendorIdentifier, defaultConsent: Bool, allowedVendorIds: Set<VendorIdentifier>) throws -> String {
        return try build(created: Date(), updated: Date(), cmpId: cmpId, cmpVersion: cmpVersion, consentScreenId: consentScreenId, consentLanguage: consentLanguage, allowedPurposes: allowedPurposes, vendorListVersion: vendorListVersion, maxVendorId: maxVendorId, defaultConsent: defaultConsent, allowedVendorIds: allowedVendorIds)
    }
}
