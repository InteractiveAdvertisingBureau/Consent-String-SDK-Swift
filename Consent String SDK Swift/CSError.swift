//
//  ConsentStringErrors.swift
//  gdprConsentStringSwift
//
//  Created by Daniel Kanaan on 4/17/18.
//  Copyright © 2018 Daniel Kanaan. All rights reserved.
//

import Foundation

public enum CSError :  Error {
    case notSupportedVersion
    case tooLittleString
    case emptyString
    case dataNotValid
    case decodingFailed
    case base64DecodingFailed
    case unknown
}
