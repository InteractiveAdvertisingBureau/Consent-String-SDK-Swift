//
//  CSVendorConsentString+Decode.swift
//  VectauryCMPConsentString
//
//  Created by Pernic on 14/05/2018.
//  Copyright © 2018 Vectaury. All rights reserved.
//

import Foundation

extension CSVendorConsentString {
    
    @objc public func decodeV1(withData bytes: Data) throws {
        self.created = Date(timeIntervalSince1970: TimeInterval(bytes.intValue(fromBit: CSConstantes.beginCreated, toBit: CSConstantes.endCreated)/10))
        self.lastUpdated = Date(timeIntervalSince1970: TimeInterval(bytes.intValue(fromBit: CSConstantes.beginLastUpdated, toBit: CSConstantes.endLastUpdated)/10))
        self.cmpId = bytes.intValue(fromBit: CSConstantes.beginCmpId, toBit: CSConstantes.endCmpId)
        self.cmpVersion = bytes.intValue(fromBit: CSConstantes.beginCmpVersion, toBit: CSConstantes.endCmpVersion)
        self.consentScreen = bytes.intValue(fromBit: CSConstantes.beginConsentScreen, toBit: CSConstantes.endConsentScreen)
        self.consentLanguage = self.computeLanguage(firstLetter: bytes.intValue(fromBit: CSConstantes.beginConsentLanguageFL, toBit: CSConstantes.endConsentLanguageFL), secondLetter: bytes.intValue(fromBit: CSConstantes.beginConsentLanguageSL, toBit: CSConstantes.endConsentLanguageSL))
        self.vendorListVersion = bytes.intValue(fromBit: CSConstantes.beginVendorListVersion, toBit: CSConstantes.endVendorListVersion)
        self.purposesAllowed = self.computePurposeAllowed(bytes:bytes, begin: Int(CSConstantes.beginVendorPurposeAllowed), size: Int(CSConstantes.sizeVendorPurposeAllowed))
        self.maxVendorId = bytes.intValue(fromBit: CSConstantes.beginVendorMaxVendorId, toBit: CSConstantes.endVendorMaxVendorId)
        let encodingTypeBite = (bytes[bytes.byte(forBit: CSConstantes.beginVendorEncodingType)!] << 4) >> 7
        self.encodingType = CSVendorEncodingType(encodingTypeBite)
        self.vendorAllowed = self.computeVendorAllowed(bytes: bytes, encodingType: encodingType, maxVendorId: maxVendorId)
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
    
    private func computeVendorAllowed(bytes:Data, encodingType:CSVendorEncodingType, maxVendorId:Int64) -> IndexSet{
        
        if encodingType == .notDefined {
            return IndexSet()
        }
        
        var indexVendorAllowed = NSMutableIndexSet()
        
        if encodingType == .bitfield {
            if (bytes.count < (CSConstantes.beginVendors + maxVendorId / 8)) {
                return IndexSet()
            }
            for i in 0..<maxVendorId {
                let bitePurpose = bytes.intValue(fromBit: CSConstantes.beginVendors + i, toBit: CSConstantes.beginVendors + i)
                if (bitePurpose == 1) {
                    indexVendorAllowed.add(Int(i + 1))
                }
            }
        }
        
        if encodingType == .range {
            let defaultConsent = (bytes[bytes.byte(forBit: CSConstantes.beginVendors)!] << 5) >> 7
            
            let indexPresentVendor = NSMutableIndexSet()
            if (bytes.count < (CSConstantes.beginVendorIndexVendor / 8)) {
                return IndexSet()
            }
            let numEntries = bytes.intValue(fromBit: CSConstantes.beginVendorNumEntries, toBit: CSConstantes.endVendorNumEntries)
            var index = CSConstantes.beginVendorIndexVendor
            for _ in 0..<numEntries {
                let singleOrRange = (bytes[bytes.byte(forBit: Int64(index))!] << (index % 8)) >> 7
                
                if singleOrRange == 0 {
                    if (bytes.count < ((index + CSConstantes.sizeOfVendor) / 8)) {
                        return IndexSet()
                    }
                    let beginingIndex = index + 1
                    let endIndex = index + CSConstantes.sizeOfVendor
                    indexPresentVendor.add(Int(bytes.intValue(fromBit: Int64(beginingIndex), toBit:Int64(endIndex))))
                    index = index + CSConstantes.sizeOfVendor + 1
                }
                if singleOrRange == 1 {
                    if (bytes.count < ((index + (CSConstantes.sizeOfVendor * 2)) / 8)) {
                        return IndexSet()
                    }
                    let beginingIndexStartVendor = index + 1
                    let endIndexStartVendor = index + CSConstantes.sizeOfVendor
                    index = index + CSConstantes.sizeOfVendor
                    let startVendor = bytes.intValue(fromBit: Int64(beginingIndexStartVendor), toBit:Int64(endIndexStartVendor))
                    let beginingIndexEndVendor = index + 1
                    let endIndexEndVendor = index + CSConstantes.sizeOfVendor
                    let endVendor = bytes.intValue(fromBit: Int64(beginingIndexEndVendor), toBit:Int64(endIndexEndVendor))
                    for i in startVendor...endVendor {
                        indexPresentVendor.add(Int(i))
                    }
                    index = index + CSConstantes.sizeOfVendor + 1
                }
            }
            
            if defaultConsent == 0 {
                indexVendorAllowed = indexPresentVendor
            }
            if defaultConsent == 1 {
                for i in 1...maxVendorId {
                    if !indexPresentVendor.contains(Int(i)) {
                        indexVendorAllowed.add(Int(i))
                    }
                }
            }
        }
        
        return IndexSet(indexVendorAllowed)
    }
}
