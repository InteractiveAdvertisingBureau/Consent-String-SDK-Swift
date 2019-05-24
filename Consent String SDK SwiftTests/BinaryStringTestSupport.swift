//
//  BinaryStringTestSupport.swift
//  Consent String SDK SwiftTests
//
//  Created by Alexander Edge on 20/05/2019.
//  Copyright © 2019 Guardian News & Media Ltd. All rights reserved.
//

import Foundation

protocol BinaryStringTestSupport {
    func binaryStringRepresenting(data:Data) -> String
    func binary(string:String, isEqualToBinaryString string2:String) -> Bool
}

extension BinaryStringTestSupport {
    func binaryStringRepresenting(data:Data) -> String {
        return  data.reduce("") { (acc, byte) -> String in
            let stringRep = String(byte, radix: 2)
            let pad = 8 - stringRep.count
            let padString = "".padding(toLength: pad, withPad: "0", startingAt: 0)
            return acc + padString + stringRep
        }
    }

    func binary(string:String, isEqualToBinaryString string2:String) -> Bool {
        if abs(string.count - string2.count) > 7 {
            return false
        }
        var index = 0
        var max = string.count
        if string.count > string2.count {
            max = string2.count
        }
        while index < max {
            if string[string.index(string.startIndex, offsetBy: index)] != string2[string2.index(string2.startIndex, offsetBy: index)] {
                return false
            }
            index += 1
        }
        if string.count > string2.count {
            while index < string.count {
                if string[string.index(string.startIndex, offsetBy: index)] != "0" {
                    return false
                }
                index += 1
            }
        } else {
            while index < string2.count {
                if string2[string2.index(string2.startIndex, offsetBy: index)] != "0" {
                    return false
                }
                index += 1
            }
        }
        return true
    }
}
