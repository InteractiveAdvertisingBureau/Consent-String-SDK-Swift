//
//  CSPublisherConsentString+DecodeV1.swift
//  Consent String SDK Swift
//
//  Created by Pernic on 26/07/2018.
//  Copyright © 2018 Interactive Advertising Bureau. All rights reserved.
//

import Foundation

extension CSPublisherConsentString {
    
    @objc public func decodeV1(withData bytes: Data) throws{
        self.version = bytes.intValue(fromBit: CSConstantes.beginVersion, toBit: CSConstantes.endVersion)
        self.created = Date(timeIntervalSince1970: TimeInterval(bytes.intValue(fromBit: CSConstantes.beginCreated, toBit: CSConstantes.endCreated)/10))
        self.lastUpdated = Date(timeIntervalSince1970: TimeInterval(bytes.intValue(fromBit: CSConstantes.beginLastUpdated, toBit: CSConstantes.endLastUpdated)/10))
        self.cmpId = bytes.intValue(fromBit: CSConstantes.beginCmpId, toBit: CSConstantes.endCmpId)
        self.cmpVersion = bytes.intValue(fromBit: CSConstantes.beginCmpVersion, toBit: CSConstantes.endCmpVersion)
        self.consentScreen = bytes.intValue(fromBit: CSConstantes.beginConsentScreen, toBit: CSConstantes.endConsentScreen)
        self.consentLanguage = self.computeLanguage(firstLetter: bytes.intValue(fromBit: CSConstantes.beginConsentLanguageFL, toBit: CSConstantes.endConsentLanguageFL), secondLetter: bytes.intValue(fromBit: CSConstantes.beginConsentLanguageSL, toBit: CSConstantes.endConsentLanguageSL))
        self.vendorListVersion = bytes.intValue(fromBit: CSConstantes.beginVendorListVersion, toBit: CSConstantes.endVendorListVersion)
        self.publisherPurposesVersion = bytes.intValue(fromBit: CSConstantes.beginPublisherPurposeVersion, toBit: CSConstantes.endPublisherPurposeVersion)
        self.standardPurposesAllowed = computePurposeAllowed(bytes:bytes, begin: Int(CSConstantes.beginStandartPurposeAllowed), size: Int(CSConstantes.sizeStandartPurposeAllowed))
        self.numberCustomPurposes = bytes.intValue(fromBit: CSConstantes.beginNumberCustomPurposes, toBit: CSConstantes.endNumberCustomPurposes)
        self.customPurposesAllowed = computePurposeAllowed(bytes:bytes, begin: Int(CSConstantes.beginCustomPurposeAllowed), size: Int(numberCustomPurposes))
    }
    
    private func computeLanguage(firstLetter: Int64, secondLetter: Int64) -> String {
        var languageString = ""
        let assciFirstLetter = CSConstantes.positionAsciiA + Int(firstLetter)
        let assciSecondLetter = CSConstantes.positionAsciiA + Int(secondLetter)
        languageString.append(Character(UnicodeScalar(assciFirstLetter)!))
        languageString.append(Character(UnicodeScalar(assciSecondLetter)!))
        return languageString
    }
    
    private func computePurposeAllowed(bytes :Data, begin:Int, size: Int) -> IndexSet{
        let indexPurposeAllowed = NSMutableIndexSet()
        
        for i in 0..<size {
            let bitePurpose = bytes.intValue(fromBit: Int64(begin + i), toBit: Int64(begin + i))
            if (bitePurpose == 1) {
                indexPurposeAllowed.add(Int(i) + 1)
            }
        }
        
        return IndexSet(indexPurposeAllowed)
    }

}
