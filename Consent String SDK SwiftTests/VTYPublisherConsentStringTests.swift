//
//  CSPublisherConsentString.swift
//  VectauryCMPConsentStringTests
//
//  Created by Pernic on 16/05/2018.
//  Copyright © 2018 Vectaury. All rights reserved.
//

import XCTest
@testable import Consent_String_SDK_Swift

class CSPublisherConsentStringTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceDecode() {
        let consentString = "BN5lERiOMYEdiAOAWeFRAAAMYAAaJ2o="
        let data = Data(base64Encoded: consentString.base64Padded)!
        self.measure {
            let _ = CSPublisherConsentString(withData: data)
        }
    }
    
    func testPerformanceEncode() {
        let consentString = "BN5lERiOMYEdiAOAWeFRAAAMYAAaJ2o="
        let data = Data(base64Encoded: consentString.base64Padded)!
        let consentStringFormated = CSPublisherConsentString(withData: data)
        self.measure {
           let _ = consentStringFormated?.encode()
            
        }
    }
    
    func testGeneralData() {
        let consentString = "BN5lERiOMYEdiAOAWeFRAAAMYAAaJ2o="
        let data = Data(base64Encoded: consentString.base64Padded)!
        let consentStringFormated = CSPublisherConsentString(withData: data)
        
        if (consentStringFormated == nil) {
            XCTFail()
        }
        
        XCTAssertEqual(consentStringFormated!.version, 1)
        XCTAssertEqual(Int(consentStringFormated!.created.timeIntervalSince1970), 1492466185)
        XCTAssertEqual(Int(consentStringFormated!.lastUpdated.timeIntervalSince1970), 1524002185)
        XCTAssertEqual(consentStringFormated!.cmpId, 14)
        XCTAssertEqual(consentStringFormated!.cmpVersion, 22)
        XCTAssertEqual(consentStringFormated!.consentScreen, 30)
        XCTAssertEqual(consentStringFormated!.consentLanguage, "FR")
        XCTAssertEqual(consentStringFormated!.vendorListVersion, 0)
    }
    
    func testStandartPurposeAllowed() {
        
        let consentStringArray = [
            "BN5lERiOMYEdiAOAWeFRAAAMYAAaJ2o="
        ]
        let testPurposes:[([[Int]],[[Int]])] = [//array of tuples of array of allowed ranges and not allowed ranges
            ([[2,3],[20,21],[23,23]],[[1,1],[4,19],[22,22],[24,24]])
        ]
        let consentString:CSPublisherConsentString = CSPublisherConsentString()
        var purposeAllowed:IndexSet
        for (index,string) in consentStringArray.enumerated() {
            do {
                try consentString.decode(withData: Data(base64Encoded: string.base64Padded)!)
                purposeAllowed = consentString.standardPurposesAllowed
                let purposeAllowedRanges = testPurposes[index].0
                for purposeRange in purposeAllowedRanges {
                    for purpose in purposeRange[0]...purposeRange[1] {
                        XCTAssert(purposeAllowed.contains(purpose))
                        XCTAssert(consentString.isStandardPurposeAllowed(purposeId: Int8(purpose)))
                    }
                }
                let purposesNotAllowedRanges = testPurposes[index].1
                for purposeRange in purposesNotAllowedRanges {
                    for neggedPurpose in purposeRange[0]...purposeRange[1] {
                        XCTAssert(!purposeAllowed.contains(neggedPurpose))
                        XCTAssert(!consentString.isStandardPurposeAllowed(purposeId: Int8(neggedPurpose)))
                    }
                }
            }catch {
                XCTFail()
            }
        }
    }
    
    func testCustomPurposeAllowed() {
        
        let consentStringArray = [
            "BN5lERiOMYEdiAOAWeFRAAAMYAAaJ2o="
        ]
        let testPurposes:[([[Int]],[[Int]])] = [//array of tuples of array of allowed ranges and not allowed ranges
            ([[1,2],[4,5],[7,7],[9,9]],[[3,3],[6,6],[8,8]])
        ]
        let consentString:CSPublisherConsentString = CSPublisherConsentString()
        var purposeAllowed:IndexSet
        for (index,string) in consentStringArray.enumerated() {
            do {
                try consentString.decode(withData: Data(base64Encoded: string.base64Padded)!)
                purposeAllowed = consentString.customPurposesAllowed
                let purposeAllowedRanges = testPurposes[index].0
                for purposeRange in purposeAllowedRanges {
                    for purpose in purposeRange[0]...purposeRange[1] {
                        XCTAssert(purposeAllowed.contains(purpose))
                        XCTAssert(consentString.isCustomPurposeAllowed(purposeId: purpose))
                    }
                }
                let purposesNotAllowedRanges = testPurposes[index].1
                for purposeRange in purposesNotAllowedRanges {
                    for neggedPurpose in purposeRange[0]...purposeRange[1] {
                        XCTAssert(!purposeAllowed.contains(neggedPurpose))
                        XCTAssert(!consentString.isCustomPurposeAllowed(purposeId: neggedPurpose))
                    }
                }
            } catch {
                XCTFail()
            }
            
        }
    }
    
    func testEncode() {
        
        let consentStringFormated = CSPublisherConsentString(version: 1, created: Date(timeIntervalSince1970: 1454741245), lastUpdated: Date(timeIntervalSince1970: 1454741245), cmpId: 45, cmpVersion: 21, consentScreen: 2, consentLanguage: "FR", vendorListVersion: 1, publisherPurposesVersion: 2, standardPurposesAllowed: IndexSet(integersIn: 1..<5), numberCustomPurposes: 43, customPurposesAllowed: IndexSet(integersIn: 1..<5))
        
        let dataCopie = consentStringFormated.encode()
        
        let consentStringCopie = dataCopie.base64EncodedString()
        XCTAssertEqual(consentStringCopie, "BNjF+XiNjF+XiAtAVCFRABAC8AAAr8AAAAAAAA==")
    }
    
    func testAddCustomPurpose() {
        
        let consentStringFormated = CSPublisherConsentString(version: 1, created: Date(timeIntervalSince1970: 1454741245), lastUpdated: Date(timeIntervalSince1970: 1454741245), cmpId: 45, cmpVersion: 21, consentScreen: 2, consentLanguage: "FR", vendorListVersion: 1, publisherPurposesVersion: 2, standardPurposesAllowed: IndexSet(integersIn: 1..<5), numberCustomPurposes: 43, customPurposesAllowed: IndexSet(integersIn: 1..<5))
        
        consentStringFormated.addCustomAllowedPurpose(id: 6)
        consentStringFormated.setCustomAllowedPurpose(id: 2, allowed: false)
        consentStringFormated.setCustomAllowedPurpose(id: 7, allowed: true)
        consentStringFormated.setCustomAllowedPurpose(id: 1, allowed: true)
        consentStringFormated.setCustomAllowedPurpose(id: 8, allowed: false)
        consentStringFormated.removeCustomAllowedPurpose(id: 3)
        
        let dataCopie = consentStringFormated.encode()
        
        let consentStringCopie = dataCopie.base64EncodedString()
        XCTAssertEqual(consentStringCopie, "BNjF+XiNjF+XiAtAVCFRABAC8AAArlgAAAAAAA==")
    }
    
    func testAddStandartPurpose() {
        
        let consentStringFormated = CSPublisherConsentString(version: 1, created: Date(timeIntervalSince1970: 1454741245), lastUpdated: Date(timeIntervalSince1970: 1454741245), cmpId: 45, cmpVersion: 21, consentScreen: 2, consentLanguage: "FR", vendorListVersion: 1, publisherPurposesVersion: 2, standardPurposesAllowed: IndexSet(integersIn: 1..<5), numberCustomPurposes: 43, customPurposesAllowed: IndexSet(integersIn: 1..<5))
        
        consentStringFormated.addStandardAllowedPurpose(id: 6)
        consentStringFormated.setStandardAllowedPurpose(id: 2, allowed: false)
        consentStringFormated.setStandardAllowedPurpose(id: 7, allowed: true)
        consentStringFormated.setStandardAllowedPurpose(id: 1, allowed: true)
        consentStringFormated.setStandardAllowedPurpose(id: 8, allowed: false)
        consentStringFormated.removeStandardAllowedPurpose(id: 3)
        
        let dataCopie = consentStringFormated.encode()
        
        let consentStringCopie = dataCopie.base64EncodedString()
        XCTAssertEqual(consentStringCopie, "BNjF+XiNjF+XiAtAVCFRABAClgAAr8AAAAAAAA==")
    }
    
    func testlittleString() {
        let consentString = "BN5lERiOMYEdiAOAWeFR"
        let data = Data(base64Encoded: consentString.base64Padded)!
        let consentStringFormated = CSPublisherConsentString(withData: data)
        
        if (consentStringFormated != nil && CSPublisherConsentString.errorDescription == nil) {
            XCTFail()
        }
        XCTAssertEqual(CSPublisherConsentString.errorDescription, CSError.tooLittleString)
        
    }
    
    func testV2String() {
        let consentString = "CNjF+XiNjF+XiAtAVCFRABAClgAAr8AAAAAAAA=="
        let data = Data(base64Encoded: consentString.base64Padded)!
        let consentStringFormated = CSPublisherConsentString(withData: data)
        
        if (consentStringFormated != nil && CSPublisherConsentString.errorDescription == nil) {
            XCTFail()
        }
        XCTAssertEqual(CSPublisherConsentString.errorDescription, CSError.notSupportedVersion)
        
    }
    
    func testInitString() {
        let consentString = "BN5lERiOMYEdiAOAWeFRAAAMYAAaJ2o="
        let consentStringFormated = CSPublisherConsentString(withString: consentString)
        
        if (consentStringFormated == nil) {
            XCTFail()
        }
        
        XCTAssertEqual(consentStringFormated!.version, 1)
        XCTAssertEqual(Int(consentStringFormated!.created.timeIntervalSince1970), 1492466185)
        XCTAssertEqual(Int(consentStringFormated!.lastUpdated.timeIntervalSince1970), 1524002185)
        XCTAssertEqual(consentStringFormated!.cmpId, 14)
        XCTAssertEqual(consentStringFormated!.cmpVersion, 22)
        XCTAssertEqual(consentStringFormated!.consentScreen, 30)
        XCTAssertEqual(consentStringFormated!.consentLanguage, "FR")
        XCTAssertEqual(consentStringFormated!.vendorListVersion, 0)
    }
    
    
}
