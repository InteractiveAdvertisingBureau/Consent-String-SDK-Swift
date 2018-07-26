//
//  CSPublisherConsentString+Encode.swift
//  VectauryCMPConsentString
//
//  Created by Pernic on 17/05/2018.
//  Copyright © 2018 Vectaury. All rights reserved.
//

import Foundation

extension CSPublisherConsentString {
    
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
        consentStringBits = consentStringBits + pad(string: String(Int(self.publisherPurposesVersion), radix:2), toSize: Int(CSConstantes.sizePublisherPurposeVersion))
        consentStringBits = consentStringBits + encodePurposeAllowed(index: self.standardPurposesAllowed, size: Int(CSConstantes.sizeStandartPurposeAllowed) )
        consentStringBits = consentStringBits + pad(string: String(Int(self.numberCustomPurposes), radix:2), toSize: Int(CSConstantes.sizeNumberCustomPurposes))
        consentStringBits = consentStringBits + encodePurposeAllowed(index: self.customPurposesAllowed, size: Int(self.numberCustomPurposes))
        
        return consentStringBits.base2Padded.toData()!
    }
    
    private func encodePurposeAllowed(index: IndexSet, size: Int) -> String{
        var purposeAllowedString = ""
        
        for i in 1...size {
            if index.contains(i) {
                purposeAllowedString = purposeAllowedString + "1"
            } else {
                purposeAllowedString = purposeAllowedString + "0"
            }
        }
        return purposeAllowedString
    }
    
    private func pad(string : String, toSize: Int) -> String {
        var padded = string
        for _ in 0..<(toSize - string.count) {
            padded = "0" + padded
        }
        return padded
    }
    
    private func encodeLanguage(index : String.UnicodeScalarView.Index) -> Int {
        let letters = self.consentLanguage.unicodeScalars
        return Int(letters[index].value) - CSConstantes.positionAsciiA
    }
}
