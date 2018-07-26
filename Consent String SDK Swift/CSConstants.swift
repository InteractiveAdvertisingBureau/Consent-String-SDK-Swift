//
//  VTYCMPConstants.swift
//  VectauryCMPConsentString
//
//  Created by Pernic on 14/05/2018.
//  Copyright © 2018 Vectaury. All rights reserved.
//

import Foundation

class CSConstantes {
    
    // Position of element in Consent String General
    static let beginVersion : Int64 = 0
    static let endVersion : Int64 = 5
    static let beginCreated : Int64 = 6
    static let endCreated : Int64 = 41
    static let beginLastUpdated : Int64 = 42
    static let endLastUpdated : Int64 = 77
    static let beginCmpId : Int64 = 78
    static let endCmpId : Int64 = 89
    static let beginCmpVersion : Int64 = 90
    static let endCmpVersion : Int64 = 101
    static let beginConsentScreen : Int64 = 102
    static let endConsentScreen : Int64 = 107
    static let beginConsentLanguageFL : Int64 = 108
    static let endConsentLanguageFL : Int64 = 113
    static let beginConsentLanguageSL : Int64 = 114
    static let endConsentLanguageSL : Int64 = 119
    static let beginVendorListVersion : Int64 = 120
    static let endVendorListVersion : Int64 = 131
    static let sizeVersion = endVersion - beginVersion + 1
    static let sizeCreated = endCreated - beginCreated + 1
    static let sizeLastUpdated = endLastUpdated - beginLastUpdated + 1
    static let sizeCmpId = endCmpId - beginCmpId + 1
    static let sizeCmpVersion = endCmpVersion - beginCmpVersion + 1
    static let sizeConsentScreen = endConsentScreen - beginConsentScreen + 1
    static let sizeConsentLanguageFL = endConsentLanguageFL - beginConsentLanguageFL + 1
    static let sizeConsentLanguageSL = endConsentLanguageSL - beginConsentLanguageSL + 1
    static let sizeVendorListVersion = endVendorListVersion - beginVendorListVersion + 1
    static let positionAsciiA = 65
    
    // Position of element in Consent String Vendor
    static let beginVendorPurposeAllowed : Int64 = 132
    static let endVendorPurposeAllowed : Int64 = 155
    static let beginVendorMaxVendorId : Int64 = 156
    static let endVendorMaxVendorId : Int64 = 171
    static let beginVendorEncodingType : Int64 = 172
    static let beginVendors : Int64 = 173
    static let beginVendorNumEntries : Int64 = 174
    static let endVendorNumEntries : Int64 = 185
    static let beginVendorIndexVendor : Int64 = 186
    static let sizeOfVendor : Int64 = 16
    static let sizeVendorPurposeAllowed = endVendorPurposeAllowed - beginVendorPurposeAllowed + 1
    static let sizeVendorMaxVendorId = endVendorMaxVendorId - beginVendorMaxVendorId + 1
    static let sizeVendorOfNumEntries = 12
    
    // Position of element in Consent String Publisher
    static let beginPublisherPurposeVersion : Int64 = 132
    static let endPublisherPurposeVersion : Int64 = 143
    static let beginStandartPurposeAllowed : Int64 = 144
    static let endStandartPurposeAllowed : Int64 = 167
    static let beginNumberCustomPurposes : Int64 = 168
    static let endNumberCustomPurposes : Int64 = 173
    static let beginCustomPurposeAllowed : Int64 = 174
    static let sizeStandartPurposeAllowed = endStandartPurposeAllowed - beginStandartPurposeAllowed + 1
    static let sizePublisherPurposeVersion = endPublisherPurposeVersion - beginPublisherPurposeVersion + 1
    static let sizeNumberCustomPurposes = endNumberCustomPurposes - beginNumberCustomPurposes + 1
    
    static let sizeOfByte : Int64 = 8
    
    
    
    
}
