//
//  CSPublisherConsentString+Decode.swift
//  VectauryCMPConsentString
//
//  Created by Pernic on 16/05/2018.
//  Copyright © 2018 Vectaury. All rights reserved.
//

import Foundation

extension CSPublisherConsentString {
    
    @objc public func decode(withData bytes: Data) throws {
        if (bytes.count < (CSConstantes.endNumberCustomPurposes / 8)) {
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
