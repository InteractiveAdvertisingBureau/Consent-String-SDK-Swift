//
//  CSVendorConsentString+Decode.swift
//  Consent String SDK Swift
//
//  Created by Pernic on 25/07/2018.
//  Copyright © 2018 Interactive Advertising Bureau. All rights reserved.
//

import Foundation

extension CSVendorConsentString {
    
    @objc public func decode(withData bytes: Data) throws {
        if (bytes.count < (CSConstantes.beginVendors / 8)) {
            throw CSError.tooLittleString
        }
        self.version = bytes.intValue(fromBit: CSConstantes.beginVersion, toBit: CSConstantes.endVersion)
        if (version > 1) {
            throw CSError.notSupportedVersion
        }
        
        do {
            try self.decodeV1(withData: bytes)
        } catch  let error as CSError {
            throw error
        }
    }
}
