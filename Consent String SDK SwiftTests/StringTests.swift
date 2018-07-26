//
//  StringTests.swift
//  VectauryCMPConsentStringTests
//
//  Created by Pernic on 16/05/2018.
//  Copyright © 2018 Vectaury. All rights reserved.
//

import XCTest
@testable import Consent_String_SDK_Swift

class StringTests: XCTestCase {
    
    let base64 = ["BOMexSfOMexSfAAABAENAA////ABSABgACAAIA",
                  "BOMexSfOMexSfAAABAENAA////ABSABgACBAAA",
                  "BOMexSfOMexSfAAABAENABAAEAABSABgACBAAA",
                  "BOMexSfOMexSfAAABAENABAAEAABRVVVAA",
                  "BOMexSfOMexSfAAABAENABAAEAABQAIAAA",
                  "BOMexSfOMexSfAAABAENABAAEAABQAIAgA",
                  "BOM03lPOM03lPAAABAENAAAAAAABR//g"
    ]
    
    let binaries = [
        "000001001110001100011110110001010010011111001110001100011110110001010010011111000000000000000000000001000000000100001101000000000000111111111111111111111111000000000001010010000000000001100000000000000010000000000000001",
        "000001001110001100011110110001010010011111001110001100011110110001010010011111000000000000000000000001000000000100001101000000000000111111111111111111111111000000000001010010000000000001100000000000000010000001000000000",
        "000001001110001100011110110001010010011111001110001100011110110001010010011111000000000000000000000001000000000100001101000000000001000000000000000100000000000000000001010010000000000001100000000000000010000001000000000",
        "0000010011100011000111101100010100100111110011100011000111101100010100100111110000000000000000000000010000000001000011010000000000010000000000000001000000000000000000010100010101010101010101010",
        "0000010011100011000111101100010100100111110011100011000111101100010100100111110000000000000000000000010000000001000011010000000000010000000000000001000000000000000000010100000000000010000000000",
        "0000010011100011000111101100010100100111110011100011000111101100010100100111110000000000000000000000010000000001000011010000000000010000000000000001000000000000000000010100000000000010000000001",
        "0000010011100011001101001101111001010011110011100011001101001101111001010011110000000000000000000000010000000001000011010000000000000000000000000000000000000000000000010100011111111111111"
    ]
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPadding() {
        var string = "BOMXuBxOMXuBxAABAENAAAAAAAAoAAA"
        XCTAssert(string.base64Padded == "BOMXuBxOMXuBxAABAENAAAAAAAAoAAA=", string.base64Padded)
        string = "BOMXuBxOMXuBxAABAENAAAAAAAAoAAB"
        XCTAssert(string.base64Padded == "BOMXuBxOMXuBxAABAENAAAAAAAAoAAB=", string.base64Padded)
        string = "BOMXuBxOMXuBxAABAENAAAAAAAAoA"
        XCTAssert(string.base64Padded == "BOMXuBxOMXuBxAABAENAAAAAAAAoA===", string.base64Padded)
        string = "BOMXuBxOMXuBxAABAENAAAAAAAAo"
        XCTAssert(string.base64Padded == "BOMXuBxOMXuBxAABAENAAAAAAAAo", string.base64Padded)
        string = "BOMXuBxOMXuBxAABAENAAAAAAAAoAABoo"
        XCTAssert(string.base64Padded == "BOMXuBxOMXuBxAABAENAAAAAAAAoAABoo===", string.base64Padded)
    }
    
    func testBase64Decoding() {
        
        for (index,string) in base64.enumerated() {
            let data = Data(base64Encoded: string.base64Padded)
            XCTAssert(binary(string: binaryStringRepresenting(data: data!), isEqualToBinaryString: binaries[index]))
        }
    }
    
    func testBase64Encoding() {
        let notEqual:[(String,String)] =
            [("BOMXuBxOMXuBxAABAENAAAAAAAAoAAAA",
              "BOMXuBxOMXuBxAABAENAAAAAAAAoAABA"),
             ("BOMXuBxOMXuBxAABAENAAAAAAAAoA",
              "BOMXuBxOMXuBxAABAENAAAAAAAAoAA"),
             ("BOMXuBxOMXuBxAABAENAAAAAAAAo",
              "BOMXuBxOMXuBxAABAENAAAAAAAAoA"),
             ("AA==",
              "A="),
             ("AB=",
              "ABA"),
             ("AABAA",
              "AABA"),
             ("===",
              "A")
        ]
        
        for pair in notEqual {
            let data1 = Data(base64Encoded: pair.0.base64Padded)
            let data2 = Data(base64Encoded: pair.1.base64Padded)
            XCTAssert(data1 != data2,"\(pair.0) == \(pair.1)")
        }
        
        let equal:[(String,String)] = [
            ("BOMXuBxOMXuBxAABAENAAAAAAAAoA=",
             "BOMXuBxOMXuBxAABAENAAAAAAAAoA"),
            ("BOMXuBxOMXuBxAABAENAAAAAAAAoA==",
             "BOMXuBxOMXuBxAABAENAAAAAAAAoA"),
            ("BOMXuBxOMXuBxAABAENAAAAAAAAoA===",
             "BOMXuBxOMXuBxAABAENAAAAAAAAoA")
        ]
        for pair in equal {
            let data1 = Data(base64Encoded: pair.0.base64Padded)
            let data2 = Data(base64Encoded: pair.1.base64Padded)
            XCTAssert(data1 == data2, "\(pair.0) != \(pair.1)")
        }
    }
    
    func testToData() {
        for binarie in binaries {
            XCTAssertEqual( binarie.base2Padded, binaryStringRepresenting(data: binarie.toData() ?? Data()))
        }
    }

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
