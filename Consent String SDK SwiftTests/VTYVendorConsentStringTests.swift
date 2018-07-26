//
//  VTYCMPConsentStringTests.swift
//  VectauryCMPConsentStringTests
//
//  Created by Pernic on 11/05/2018.
//  Copyright © 2018 Vectaury. All rights reserved.
//

import XCTest
@testable import Consent_String_SDK_Swift

class CSVendorConsentStringTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceDecode() {
        let consentString = "BOO1oduOO1oduABABBFRABgAAAAAGABALgA"
        let data = Data(base64Encoded: consentString.base64Padded)!
        self.measure {
            let _ = CSVendorConsentString(withData: data)
        }
    }
    
    func testPerformanceEncode() {
        let consentString = "BN5lERiOMYEdiAOAWeFRAAYAAaAAptQ"
        let data = Data(base64Encoded: consentString.base64Padded)!
        let consentStringFormated = CSVendorConsentString(withData: data)
        self.measure {
            let _ = consentStringFormated?.encode()
            
        }
    }
    
    func testGeneralData() {
        let consentString = "BOPPfctOPPfctBLABCFRA2gAAAAXCABALgA="
        let data = Data(base64Encoded: consentString.base64Padded)!
        let consentStringFormated = CSVendorConsentString(withData: data)
        
        if (consentStringFormated == nil) {
            XCTFail()
        }
        
        XCTAssertEqual(consentStringFormated!.version, 1)
        XCTAssertEqual(Int(consentStringFormated!.created.timeIntervalSince1970), 1528810474)
        XCTAssertEqual(Int(consentStringFormated!.lastUpdated.timeIntervalSince1970), 1528810474)
        XCTAssertEqual(consentStringFormated!.cmpId, 75)
        XCTAssertEqual(consentStringFormated!.cmpVersion, 1)
        XCTAssertEqual(consentStringFormated!.consentScreen, 2)
        XCTAssertEqual(consentStringFormated!.consentLanguage, "FR")
        XCTAssertEqual(consentStringFormated!.vendorListVersion, 54)
        XCTAssertEqual(consentStringFormated!.maxVendorId, 368)
        XCTAssertEqual(consentStringFormated!.encodingType, .range)
    }

    func testPurposesAllowed () {
        let consentStringArray = ["BOMexSfOMexSfAAABAENAA////AAoAA",
                                  "BOMexSfOMexSfAAABAENAAf///AAoAA",
                                  "BOMexSfOMexSfAAABAENAAP///AAoAA",
                                  "BOMexSfOMexSfAAABAENAAH///AAoAA",
                                  "BOMexSfOMexSfAAABAENAAD///AAoAA",
                                  "BOMexSfOMexSfAAABAENAAB///AAoAA",
                                  "BOMexSfOMexSfAAABAENAAA///AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAf//AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAP//AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAH//AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAD//AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAB//AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAA//AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAf/AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAP/AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAH/AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAD/AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAB/AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAA/AAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAAfAAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAAPAAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAAHAAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAADAAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAABAAoAA",
                                  "BOMexSfOMexSfAAABAENAAAAAAAAoAA"]
        var consentString:CSVendorConsentString?
        var purposesAllowed:IndexSet
        for (index,string) in consentStringArray.enumerated() {
            consentString = CSVendorConsentString(withData: Data(base64Encoded: string.base64Padded)!)
            if (consentString == nil) {
                XCTFail()
            }
            purposesAllowed = consentString!.purposesAllowed
            if (index < 24) {
                for i in index+1...24 {
                    XCTAssert(purposesAllowed.contains(i))
                    XCTAssert(consentString!.isPurposeAllowed(purposeId: Int8(i)))
                }
            }
            for i in 0..<index {
                XCTAssert(!purposesAllowed.contains(i+1))
                XCTAssert(!consentString!.isPurposeAllowed(purposeId: Int8(i + 1)))
            }
        }
    }
    
    func testVendorAllowed() {
        
        let consentStringArray = [
            "BOM03lPOM03lPAAABAENAAAAAAABSABAAcA",
            "BOM03lPOM03lPAAABAENAAAAAAABTABAAcA",
            "BOM03lPOM03lPAAABAENAAAAAAADiADgACAB0AFAAoABwA",
            "BOM03lPOM03lPAAABAENAAAAAAAAzADgACAB0AFAAoABwA"
        ]
        let testVendors:[([[Int]],[[Int]])] = [//array of tuples of array of allowed ranges and not allowed ranges
            ([[14,14]],[[0,13],[15,300]]),
            ([[1,13],[15,20]],[[14,14],[21,300]]),
            ([[1,14],[20,40],[56,56]],[[15,19],[41,55],[57,200]]),
            ([],[[1,200]])
        ]
        
        var vendorsAllowed:IndexSet
        for (index,string) in consentStringArray.enumerated() {
            let consentString:CSVendorConsentString = CSVendorConsentString(withData: Data(base64Encoded: string.base64Padded))!
            vendorsAllowed = consentString.vendorAllowed
            let vendorsAllowedRanges = testVendors[index].0
            for vendorRange in vendorsAllowedRanges {
                for vendor in vendorRange[0]...vendorRange[1] {
                    XCTAssert(vendorsAllowed.contains(vendor))
                    XCTAssert(consentString.isVendorAllowed(vendorId: vendor))
                }
            }
            let vendorsNotAllowedRanges = testVendors[index].1
            for vendorRange in vendorsNotAllowedRanges {
                for neggedVendor in vendorRange[0]...vendorRange[1] {
                    XCTAssert(!vendorsAllowed.contains(neggedVendor))
                    XCTAssert(!consentString.isVendorAllowed(vendorId: neggedVendor))
                }
            }
        }
    }
    
    func testEncode() {
        let consentStringFormated = CSVendorConsentString(version: 12, created: Date(timeIntervalSince1970: 1454741245), lastUpdated: Date(timeIntervalSince1970: 1454741650), cmpId: 75, cmpVersion: 1, consentScreen: 1, consentLanguage: "FR", vendorListVersion: 12, purposesAllowed: IndexSet([1,2]), maxVendorId: 500, encodingType: 0, vendorAllowed: IndexSet([368]))
        
        let dataCopie = consentStringFormated.encode()
        
        let consentStringCopie = dataCopie.base64EncodedString()
        XCTAssertEqual(consentStringCopie, "MNjF+XiNjF/W0BLABBFRAMwAAAAfSABALgA=")
    }
    
    func testEncodeRange() {
        
        let consentStringFormated = CSVendorConsentString(version: 1, created: Date(timeIntervalSince1970: 1454741245), lastUpdated: Date(timeIntervalSince1970: 1454741245), cmpId: 45, cmpVersion: 21, consentScreen: 2, consentLanguage: "FR", vendorListVersion: 1, purposesAllowed: IndexSet(integersIn: 1..<5), maxVendorId: 56, encodingType: 0, vendorAllowed: IndexSet(integersIn: 1..<5))
        
        let dataCopie = consentStringFormated.encode()
        
        let consentStringCopie = dataCopie.base64EncodedString()
        XCTAssertEqual(consentStringCopie, "BNjF+XiNjF+XiAtAVCFRAB8AAAADiABgACAAgA==")
    }
    
    func testEncodeRangeSingle() {
        
        let indices: IndexSet = [1, 2, 3, 6, 7, 25]
        
        let consentStringFormated = CSVendorConsentString(version: 1, created: Date(timeIntervalSince1970: 1454741245), lastUpdated: Date(timeIntervalSince1970: 1454741245), cmpId: 45, cmpVersion: 21, consentScreen: 2, consentLanguage: "FR", vendorListVersion: 1, purposesAllowed: IndexSet(integersIn: 1..<5), maxVendorId: 56, encodingType: 0, vendorAllowed: indices)
        
        let dataCopie = consentStringFormated.encode()
        
        let consentStringCopie = dataCopie.base64EncodedString()
        XCTAssertEqual(consentStringCopie, "BNjF+XiNjF+XiAtAVCFRAB8AAAADhzAABAAAAAA=")
    }
    
    func testEncodeBitfield() {
        
        let indices: IndexSet = [1, 2, 3, 6, 7, 9]
        
        let consentStringFormated = CSVendorConsentString(version: 1, created: Date(timeIntervalSince1970: 1454741245), lastUpdated: Date(timeIntervalSince1970: 1454741245), cmpId: 45, cmpVersion: 21, consentScreen: 2, consentLanguage: "FR", vendorListVersion: 1, purposesAllowed: IndexSet(integersIn: 1..<5), maxVendorId: 12, encodingType: 0, vendorAllowed: indices)
        
        let dataCopie = consentStringFormated.encode()
        
        let consentStringCopie = dataCopie.base64EncodedString()
        XCTAssertEqual(consentStringCopie, "BNjF+XiNjF+XiAtAVCFRAB8AAAAAxzQA")
    }
    
    func testaddVendor() {
        
        let indices: IndexSet = [1, 2, 3, 6, 7, 9]
        
        let consentStringFormated = CSVendorConsentString(version: 1, created: Date(timeIntervalSince1970: 1454741245), lastUpdated: Date(timeIntervalSince1970: 1454741245), cmpId: 45, cmpVersion: 21, consentScreen: 2, consentLanguage: "FR", vendorListVersion: 1, purposesAllowed: IndexSet(integersIn: 1..<5), maxVendorId: 12, encodingType: 0, vendorAllowed: indices)
        
        consentStringFormated.setAllowedVendor(id: 5, allowed: true)
        consentStringFormated.setAllowedVendor(id: 3, allowed: false)
        consentStringFormated.removeAllowedVendor(id: 9)
        consentStringFormated.addAllowedVendor(id: 4)
        
        let dataCopie = consentStringFormated.encode()
        
        let consentStringCopie = dataCopie.base64EncodedString()
        XCTAssertEqual(consentStringCopie, "BNjF+XiNjF+XiAtAVCFRAB8AAAAAdvA=")
    }
    
    func testaddpurpose() {
        
        let indices: IndexSet = [1, 2, 3, 6, 7, 9]
        
        let consentStringFormated = CSVendorConsentString(version: 1, created: Date(timeIntervalSince1970: 1454741245), lastUpdated: Date(timeIntervalSince1970: 1454741245), cmpId: 45, cmpVersion: 21, consentScreen: 2, consentLanguage: "FR", vendorListVersion: 1, purposesAllowed: IndexSet(integersIn: 1..<5), maxVendorId: 12, encodingType: 0, vendorAllowed: indices)
        
        consentStringFormated.setAllowedPurpose(id: 5, allowed: true)
        consentStringFormated.setAllowedPurpose(id: 3, allowed: false)
        consentStringFormated.removeAllowedPurpose(id: 1)
        consentStringFormated.addAllowedPurpose(id: 4)
        
        let dataCopie = consentStringFormated.encode()
        
        let consentStringCopie = dataCopie.base64EncodedString()
        XCTAssertEqual(consentStringCopie, "BNjF+XiNjF+XiAtAVCFRABWAAAAAxzQA")
    }
    
    func testlittleString() {
        let consentString = "BN5lERiOMYEdiAOAWeFR"
        let data = Data(base64Encoded: consentString.base64Padded)!
        let consentStringFormated = CSVendorConsentString(withData: data)
        
        if (consentStringFormated != nil && CSVendorConsentString.errorDescription == nil) {
            XCTFail()
        }
        XCTAssertEqual(CSVendorConsentString.errorDescription, CSError.tooLittleString)
        
    }
    
    func testV2String() {
        let consentString = "CNjF+XiNjF+XiAtAVCFRABAClgAAr8AAAAAAAA=="
        let data = Data(base64Encoded: consentString.base64Padded)!
        let consentStringFormated = CSVendorConsentString(withData: data)
        
        if (consentStringFormated != nil && CSVendorConsentString.errorDescription == nil) {
            XCTFail()
        }
        XCTAssertEqual(CSVendorConsentString.errorDescription, CSError.notSupportedVersion)
        
    }
    
    func testInitWithUserDefault() {
        UserDefaults.standard.set("BOPPfctOPPfctBLABCFRA2gAAAAXCABALgA=", forKey: "IABConsent_ConsentString")
        UserDefaults.standard.synchronize()
        
        let consentStringFormated = CSVendorConsentString()
        
        if (consentStringFormated == nil) {
            XCTFail()
        }
        
        XCTAssertEqual(consentStringFormated!.version, 1)
        XCTAssertEqual(Int(consentStringFormated!.created.timeIntervalSince1970), 1528810474)
        XCTAssertEqual(Int(consentStringFormated!.lastUpdated.timeIntervalSince1970), 1528810474)
        XCTAssertEqual(consentStringFormated!.cmpId, 75)
        XCTAssertEqual(consentStringFormated!.cmpVersion, 1)
        XCTAssertEqual(consentStringFormated!.consentScreen, 2)
        XCTAssertEqual(consentStringFormated!.consentLanguage, "FR")
        XCTAssertEqual(consentStringFormated!.vendorListVersion, 54)
        XCTAssertEqual(consentStringFormated!.maxVendorId, 368)
        XCTAssertEqual(consentStringFormated!.encodingType, .range)
    }
    
    
    func testInitString() {
        let consentString = "BOPPfctOPPfctBLABCFRA2gAAAAXCABALgA="
        let consentStringFormated = CSVendorConsentString(withString: consentString)
        
        if (consentStringFormated == nil) {
            XCTFail()
        }
        
        XCTAssertEqual(consentStringFormated!.version, 1)
        XCTAssertEqual(Int(consentStringFormated!.created.timeIntervalSince1970), 1528810474)
        XCTAssertEqual(Int(consentStringFormated!.lastUpdated.timeIntervalSince1970), 1528810474)
        XCTAssertEqual(consentStringFormated!.cmpId, 75)
        XCTAssertEqual(consentStringFormated!.cmpVersion, 1)
        XCTAssertEqual(consentStringFormated!.consentScreen, 2)
        XCTAssertEqual(consentStringFormated!.consentLanguage, "FR")
        XCTAssertEqual(consentStringFormated!.vendorListVersion, 54)
        XCTAssertEqual(consentStringFormated!.maxVendorId, 368)
        XCTAssertEqual(consentStringFormated!.encodingType, .range)
    }
    
}
