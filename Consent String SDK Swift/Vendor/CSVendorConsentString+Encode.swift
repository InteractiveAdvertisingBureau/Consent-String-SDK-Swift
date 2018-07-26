//
//  CSVendorConsentString+Encode.swift
//  VectauryCMPConsentString
//
//  Created by Pernic on 14/05/2018.
//  Copyright © 2018 Vectaury. All rights reserved.
//

import Foundation

extension CSVendorConsentString {

    @objc public func encode() -> Data {
        
        var consentStringBits = ""
        
        consentStringBits = pad(string: String(self.version, radix:2), toSize: Int(CSConstantes.sizeVersion))
        consentStringBits = consentStringBits + pad(string: String(Int(self.created.timeIntervalSince1970 * 10), radix:2), toSize: Int(CSConstantes.sizeCreated))
        consentStringBits = consentStringBits + pad(string: String(Int(self.lastUpdated.timeIntervalSince1970 * 10), radix:2), toSize: Int(CSConstantes.sizeLastUpdated))
        consentStringBits = consentStringBits + pad(string: String(Int(self.cmpId), radix:2), toSize: Int(CSConstantes.sizeCmpId))
        consentStringBits = consentStringBits + pad(string: String(Int(self.cmpVersion), radix:2), toSize: Int(CSConstantes.sizeCmpVersion))
        consentStringBits = consentStringBits + pad(string: String(Int(self.consentScreen), radix:2), toSize: Int(CSConstantes.sizeConsentScreen))
        consentStringBits = consentStringBits + pad(string: String(encodeLanguage(index: .init(encodedOffset: 0)), radix:2), toSize: Int(CSConstantes.sizeConsentLanguageFL))
        consentStringBits = consentStringBits + pad(string: String(encodeLanguage(index: .init(encodedOffset: 1)), radix:2), toSize: Int(CSConstantes.sizeConsentLanguageSL))
        consentStringBits = consentStringBits + pad(string: String(Int(self.vendorListVersion), radix:2), toSize: Int(CSConstantes.sizeVendorListVersion))
        consentStringBits = consentStringBits + encodePurposeAllowed()
        consentStringBits = consentStringBits + pad(string: String(Int(self.maxVendorId), radix:2), toSize: Int(CSConstantes.sizeVendorMaxVendorId))
        consentStringBits = consentStringBits + encodeVendor()
        
        return consentStringBits.base2Padded.toData()!
    }
    
    private func encodeVendor() -> String {
        
        let stringEncodeByrange = encodeVendorByRange()
        
        if stringEncodeByrange.count > self.maxVendorId + 1 {
            return encodeVendorByBitField()
        }
        
        return stringEncodeByrange
    }
    
    private func encodeVendorByBitField() -> String {
        var bitField = "0"
        if (self.maxVendorId == 0) {
            return bitField
        }
        for i in 1...Int(self.maxVendorId) {
            if (self.vendorAllowed.contains(i)) {
                bitField = bitField + "1"
            } else {
                bitField = bitField + "0"
            }
        }
        return bitField
    }
    
    private func encodeVendorByRange() -> String {
        
        if (self.maxVendorId == 0) {
            return "10"
        }
        
        var rangeViewOptIn = "10" + pad(string: String(NSIndexSet(indexSet: self.vendorAllowed).rangeCount(), radix:2), toSize: CSConstantes.sizeVendorOfNumEntries)
        rangeViewOptIn = rangeViewOptIn + encodeIndex(index: self.vendorAllowed)
        
        let indexOptOut = IndexSet(integersIn: 1...Int(self.maxVendorId)).subtracting(self.vendorAllowed)
        var rangeViewOptOut = "11" + pad(string: String(NSIndexSet(indexSet: indexOptOut).rangeCount(), radix:2), toSize: CSConstantes.sizeVendorOfNumEntries)
        rangeViewOptOut = rangeViewOptOut + encodeIndex(index: indexOptOut)
        
        return rangeViewOptIn.count > rangeViewOptOut.count ? rangeViewOptOut : rangeViewOptIn
    }
    
    private func encodeIndex(index : IndexSet) -> String {
        var rangeView = ""
        for (_,c) in index.rangeView.enumerated() {
            if (c.count == 1) {
                rangeView = rangeView + "0" + pad(string: String(c.first!, radix:2), toSize: Int(CSConstantes.sizeOfVendor))
            } else {
                rangeView = rangeView + "1" + pad(string: String(c.first!, radix:2), toSize: Int(CSConstantes.sizeOfVendor)) + pad(string: String(c.last!, radix:2), toSize: Int(CSConstantes.sizeOfVendor))
            }
        }
        return rangeView
    }
    
    private func encodePurposeAllowed() -> String {
        var purposeAllowedString = ""
        
        for i in 1...Int(CSConstantes.sizeVendorPurposeAllowed) {
            if self.purposesAllowed.contains(i) {
                purposeAllowedString = purposeAllowedString + "1"
            } else {
                purposeAllowedString = purposeAllowedString + "0"
            }
        }
        return purposeAllowedString
    }
    
    private func encodeLanguage(index : String.UnicodeScalarView.Index) -> Int {
        let letters = self.consentLanguage.unicodeScalars
        return Int(letters[index].value) - CSConstantes.positionAsciiA
    }
    
    private func pad(string : String, toSize: Int) -> String {
        var padded = string
        if (string.count >= toSize) {
            return padded
        }
        for _ in 0..<(toSize - string.count) {
            padded = "0" + padded
        }
        return padded
    }

}
