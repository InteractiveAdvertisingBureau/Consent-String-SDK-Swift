//
//  ConsentStringBuilderTests.swift
//  Consent String SDK SwiftTests
//
//  Created by Alexander Edge on 17/05/2019.
//  Copyright © 2019 Guardian News & Media Ltd. All rights reserved.
//

import XCTest
@testable import Consent_String_SDK_Swift

class ConsentStringBuilderTests: XCTestCase, BinaryStringTestSupport {

    var builder: ConsentStringBuilder!

    override func setUp() {
        super.setUp()
        builder = ConsentStringBuilder()
    }

    override func tearDown() {
        builder = nil
        super.tearDown()
    }

    func testEncodingInt() {
        XCTAssertEqual(builder.encode(integer: 1, toLength: NSRange.version.length), "000001")
    }

    func testEncodingDate() {
        let date = Date(timeIntervalSince1970: 1510082155.4)
        XCTAssertEqual(builder.encode(date: date, toLength: NSRange.updated.length), "001110000100000101000100000000110010")
    }

    func testEncodingBitfield() {
        XCTAssertEqual(builder.encode(vendorBitFieldForVendors: [2,4,6,8,10,12,14,16,18,20], maxVendorId: 20), "01010101010101010101")
    }

    func testEncodingNoVendorRanges() {
        XCTAssertEqual(builder.encode(vendorRanges: []), "000000000000")
    }

    func testEncodingSingleVendorIdRange() {
        XCTAssertEqual(builder.encode(vendorRanges: [9...9]), "00000000000100000000000001001")
    }

    func testEncodingMultipleVendorIdRange() {
        XCTAssertEqual(builder.encode(vendorRanges: [1...3]), "000000000001100000000000000010000000000000011")
    }

    func testEncodingMixedVendorRanges() {
        XCTAssertEqual(builder.encode(vendorRanges: [1...3, 9...9]), "00000000001010000000000000001000000000000001100000000000001001")
    }

    func testRangesWithDefaultConsent() {
        let allVendorIds = Set<VendorIdentifier>(0...10)
        let allowedVendorIds = Set<VendorIdentifier>(1...3)
        XCTAssertEqual(builder.ranges(for: allowedVendorIds, in: allVendorIds, defaultConsent: true), [0...0, 4...10])
    }

    func testRangesWithoutDefaultConsent() {
        let allVendorIds = Set<VendorIdentifier>(0...10)
        let allowedVendorIds = Set<VendorIdentifier>(1...3)
        XCTAssertEqual(builder.ranges(for: allowedVendorIds, in: allVendorIds, defaultConsent: false), [1...3])
    }

    func testUsesRangesOverBitField() throws {
        XCTAssertEqual(try builder.build(created: Date(timeIntervalSince1970: 1510082155.4), updated: Date(timeIntervalSince1970: 1510082155.4), cmpId: 7, cmpVersion: 1, consentScreenId: 3, consentLanguage: "EN", allowedPurposes: [.storageAndAccess, .personalization, .adSelection], vendorListVersion: 8, maxVendorId: 2011, defaultConsent: true, allowedVendorIds: Set<VendorIdentifier>(1...2011).subtracting([9])), "BOEFEAyOEFEAyAHABDENAI4AAAB9vABAASA")
    }

    func testUsesBitFieldOverRanges() throws {
        let vendorIds = ClosedRange<VendorIdentifier>(1...234).compactMap { $0.isMultiple(of: 2) ? nil : $0 }
        XCTAssertEqual(try builder.build(created: Date(timeIntervalSince1970: 1510082155.4), updated: Date(timeIntervalSince1970: 1510082155.4), cmpId: 7, cmpVersion: 1, consentScreenId: 3, consentLanguage: "EN", allowedPurposes: [.storageAndAccess, .personalization, .adSelection], vendorListVersion: 8, maxVendorId: 2011, defaultConsent: true, allowedVendorIds: Set(vendorIds)), "BOEFEAyOEFEAyAHABDENAI4AAAB9tVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
    }

    func testFailsWithInvalidLanguageCode() {
        XCTAssertThrowsError(try builder.build(cmpId: 0, cmpVersion: 0, consentScreenId: 0, consentLanguage: "z", allowedPurposes: [], vendorListVersion: 0, maxVendorId: 1, allowedVendorIds: [1])) { error in
            guard case ConsentStringBuilder.Error.invalidLanguageCode("z") = error else {
                XCTFail("unexpected error: \(error)")
                return
            }
        }

        XCTAssertThrowsError(try builder.build(cmpId: 0, cmpVersion: 0, consentScreenId: 0, consentLanguage: "45", allowedPurposes: [], vendorListVersion: 0, maxVendorId: 1, allowedVendorIds: [1])) { error in
            guard case ConsentStringBuilder.Error.invalidLanguageCode("45") = error else {
                XCTFail("unexpected error: \(error)")
                return
            }
        }
    }

    func testUsesWebSafeBase64EncodedString() {
        XCTAssertEqual(try builder.build(created: Date(timeIntervalSince1970: 1510082155.4), updated: Date(timeIntervalSince1970: 1510082155.4), cmpId: 0, cmpVersion: 0, consentScreenId: 0, consentLanguage: "EN", allowedPurposes: .all, vendorListVersion: 1, maxVendorId: 100, defaultConsent: false, allowedVendorIds: [1,2,51,99,100]), "BOEFEAyOEFEAyAAAAAENAB-AAAAGSADgACAAQAM4AxgDIA")
    }

    func testConsentStringInitializer() throws {
        let created = Date()
        let updated = created.addingTimeInterval(50)
        let cmpId = 1
        let cmpVersion = 2
        let consentScreenId = 3
        let consentLanguage = "FR"
        let allowedPurposes: Purposes = [.adSelection]
        let vendorListVersion = 4
        let maxVendorId: VendorIdentifier = 5
        let allowedVendorIds = Set<VendorIdentifier>([2, 4])
        let consentString = try ConsentString(created: created, updated: updated, cmpId: cmpId, cmpVersion: cmpVersion, consentScreenId: consentScreenId, consentLanguage: consentLanguage, allowedPurposes: allowedPurposes, vendorListVersion: vendorListVersion, maxVendorId: maxVendorId, allowedVendorIds: allowedVendorIds)
        XCTAssertEqual(consentString.cmpId, cmpId)
        XCTAssertEqual(consentString.consentLanguage, consentLanguage)
        XCTAssertEqual(consentString.consentScreen, consentScreenId)
        XCTAssertEqual(consentString.maxVendorId, Int(maxVendorId))
        XCTAssertEqual(consentString.purposesAllowed, [3])
        XCTAssertEqual(consentString.vendorListVersion, vendorListVersion)
        XCTAssertFalse(consentString.isVendorAllowed(vendorId: 1))
        XCTAssertTrue(consentString.isVendorAllowed(vendorId: 2))
        XCTAssertFalse(consentString.isVendorAllowed(vendorId: 3))
        XCTAssertTrue(consentString.isVendorAllowed(vendorId: 4))
        XCTAssertFalse(consentString.isVendorAllowed(vendorId: 5))
    }
}
