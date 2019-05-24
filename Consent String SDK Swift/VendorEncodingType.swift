//
//  EncodingType.swift
//  Consent String SDK Swift
//
//  Created by Alexander Edge on 17/05/2019.
//  Copyright © 2019 Guardian News & Media Ltd. All rights reserved.
//

import Foundation

/// The consent encoding used. Consent string encoding logic should choose the encoding that results in the smaller output.
enum VendorEncodingType: Int {
    case bitField
    case range
}
