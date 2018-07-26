//
//  String.swift
//  gdprConsentStringSwift
//
//  Created by Daniel Kanaan on 4/17/18.
//  Copyright © 2018 Daniel Kanaan. All rights reserved.
//

import Foundation

extension String {
    
    public var base64Padded:String {
        get {
            return self.padding(toLength: ((self.count + 3) / 4) * 4,withPad: "=",startingAt: 0)
        }
    }
    
    public var base2Padded:String {
        get{
            var str = self
            while str.count % 8 != 0 {
                str = str + "0"
            }
            return str
        }
    }
    
    public func toData() -> Data? {
        
        var stringData = Data()
        
        let strPadded = self.base2Padded
        
        for i in stride(from: 0, to: strPadded.count - (strPadded.count % 8), by: 8) {
            let start = strPadded.index(strPadded.startIndex, offsetBy: i)
            let end = strPadded.index(strPadded.startIndex, offsetBy: i + 8)
            let range = start..<end
            let byteString = strPadded[range]
            
            let byteInt = UInt8(byteString, radix:2)
            if (byteInt == nil) {
                return nil
            }
            stringData.append(byteInt!)
        }
        
        return stringData
    }

    
}
