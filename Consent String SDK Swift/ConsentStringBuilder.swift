//
//  ConsentStringBuilder.swift
//  Consent String SDK Swift
//
//  Created by Alexander Edge on 17/05/2019.
//  Copyright © 2019 Guardian News & Media Ltd. All rights reserved.
//

import Foundation

public class ConsentStringBuilder: ConsentStringBuilding {

    enum Error: Swift.Error {
        case invalidLanguageCode(String)
    }

    private let version: Int = 1
    private let asciiOffset: UInt8 = 65

    public init() {}

    /// Build a v1 consent string
    ///
    /// - Parameters:
    ///   - created: Date when consent string was created
    ///   - updated: Date when consent string was last updated
    ///   - cmpId: Consent Manager Provider ID that last updated the consent string
    ///   - cmpVersion: Consent Manager Provider version
    ///   - consentScreenId: Screen number in the CMP where consent was given
    ///   - consentLanguage: Two-letter ISO639-1 language code that CMP asked for consent in
    ///   - allowedPurposes: Set of allowed purposes
    ///   - vendorListVersion: Version of vendor list used in most recent consent string update
    ///   - maxVendorId: The maximum VendorId for which consent values are given.
    ///   - defaultConsent: Default consent for VendorIds not covered by a RangeEntry. VendorIds covered by a RangeEntry have a consent value the opposite of DefaultConsent
    ///   - allowedVendorIds: VendorIds with consent
    /// - Returns: An encoded consent string
    /// - Throws: Error is string cannot be created
    public func build(created: Date, updated: Date, cmpId: Int, cmpVersion: Int, consentScreenId: Int, consentLanguage: String, allowedPurposes: Purposes, vendorListVersion: Int, maxVendorId: VendorIdentifier, defaultConsent: Bool, allowedVendorIds: Set<VendorIdentifier>) throws -> String {
        let commonBinaryString = try commonConsentBinaryString(created: created, updated: updated, cmpId: cmpId, cmpVersion: cmpVersion, consentScreenId: consentScreenId, consentLanguage: consentLanguage, allowedPurposes: allowedPurposes, vendorListVersion: vendorListVersion, maxVendorId: maxVendorId)

        // we encode by both methods (bit field and ranges) and use whichever is smallest
        let encodingUsingBitField = commonBinaryString
            .appending(bitFieldBinaryString(allowedVendorIds: allowedVendorIds, maxVendorId: maxVendorId))
            .padRight(toNearestMultipleOf: 8)
            .trimmedWebSafeBase64EncodedString()

        let encodingUsingRanges = commonBinaryString
            .appending(rangesBinaryString(allowedVendorIds: allowedVendorIds, maxVendorId: maxVendorId, defaultConsent: defaultConsent))
            .padRight(toNearestMultipleOf: 8)
            .trimmedWebSafeBase64EncodedString()

        if encodingUsingBitField.count < encodingUsingRanges.count {
            return encodingUsingBitField
        } else {
            return encodingUsingRanges
        }
    }

    func commonConsentBinaryString(created: Date, updated: Date, cmpId: Int, cmpVersion: Int, consentScreenId: Int, consentLanguage: String, allowedPurposes: Purposes, vendorListVersion: Int, maxVendorId: VendorIdentifier) throws -> String {
        var consentString = ""
        consentString.append(encode(integer: version, toLength: NSRange.version.length))
        consentString.append(encode(date: created, toLength: NSRange.created.length))
        consentString.append(encode(date: updated, toLength: NSRange.updated.length))
        consentString.append(encode(integer: cmpId, toLength: NSRange.cmpIdentifier.length))
        consentString.append(encode(integer: cmpVersion, toLength: NSRange.cmpVersion.length))
        consentString.append(encode(integer: consentScreenId, toLength: NSRange.consentScreen.length))

        guard consentLanguage.count == 2, let firstLanguageCharacter = consentLanguage.uppercased()[consentLanguage.index(consentLanguage.startIndex, offsetBy: 0)].asciiValue, firstLanguageCharacter >= asciiOffset,
            let secondLanguageCharacter = consentLanguage.uppercased()[consentLanguage.index(consentLanguage.startIndex, offsetBy: 1)].asciiValue, secondLanguageCharacter >= asciiOffset else {
            throw Error.invalidLanguageCode(consentLanguage)
        }

        consentString.append(encode(integer: firstLanguageCharacter - asciiOffset, toLength: NSRange.consentLanguage.length / 2))
        consentString.append(encode(integer: secondLanguageCharacter - asciiOffset, toLength: NSRange.consentLanguage.length / 2))
        consentString.append(encode(integer: vendorListVersion, toLength: NSRange.vendorListVersion.length))
        consentString.append(encode(purposeBitFieldForPurposes: allowedPurposes))
        consentString.append(encode(integer: maxVendorId, toLength: NSRange.maxVendorIdentifier.length))
        return consentString
    }

    func bitFieldBinaryString(allowedVendorIds: Set<VendorIdentifier>, maxVendorId: VendorIdentifier) -> String {
        var consentString = ""
        consentString.append(encode(integer: VendorEncodingType.bitField.rawValue, toLength: NSRange.encodingType.length))
        consentString.append(encode(vendorBitFieldForVendors: allowedVendorIds, maxVendorId: maxVendorId))
        return consentString
    }

    func rangesBinaryString(allowedVendorIds: Set<VendorIdentifier>, maxVendorId: VendorIdentifier, defaultConsent: Bool) -> String {
        var consentString = ""
        consentString.append(encode(integer: VendorEncodingType.range.rawValue, toLength: NSRange.encodingType.length))
        consentString.append(encode(integer: defaultConsent ? 1 : 0, toLength: NSRange.defaultConsent.length))
        consentString.append(encode(vendorRanges: ranges(for: allowedVendorIds, in: Set(1...maxVendorId), defaultConsent: defaultConsent)))
        return consentString
    }

    func encode(integer: UInt8, toLength length: Int) -> String {
        return String(integer, radix: 2).padLeft(toLength: length)
    }

    func encode(integer: Int16, toLength length: Int) -> String {
        return String(integer, radix: 2).padLeft(toLength: length)
    }

    func encode(integer: Int, toLength length: Int) -> String {
        return String(integer, radix: 2).padLeft(toLength: length)
    }

    func encode(date: Date, toLength length: Int) -> String {
        return encode(integer: Int(date.timeIntervalSince1970 * 10), toLength: length)
    }

    public func encode(purposeBitFieldForPurposes purposes: Purposes) -> String {
        return encode(integer: purposes.rawValue, toLength: NSRange.purposes.length)
    }

    public func encode(vendorBitFieldForVendors vendors: Set<VendorIdentifier>, maxVendorId: VendorIdentifier) -> String {
        return (1...maxVendorId).reduce("") { $0 + (vendors.contains($1) ? "1" : "0") }
    }

    func encode(vendorRanges ranges: [ClosedRange<VendorIdentifier>]) -> String {
        var string = ""
        string.append(encode(integer: ranges.count, toLength: NSRange.numberOfEntries.length))
        for range in ranges {
            if range.count == 1 {
                // single entry
                string.append(encode(integer: 0, toLength: 1))
                string.append(encode(integer: range.lowerBound, toLength: ConsentString.vendorIdentifierSize))
            } else {
                // range entry
                string.append(encode(integer: 1, toLength: 1))
                string.append(encode(integer: range.lowerBound, toLength: ConsentString.vendorIdentifierSize))
                string.append(encode(integer: range.upperBound, toLength: ConsentString.vendorIdentifierSize))
            }
        }
        return string
    }

    func ranges(for allowedVendorIds: Set<VendorIdentifier>, in allVendorIds: Set<VendorIdentifier>, defaultConsent: Bool) -> [ClosedRange<VendorIdentifier>] {
        let vendorsToEncode = defaultConsent ? allVendorIds.subtracting(allowedVendorIds).sorted() : allowedVendorIds.sorted()

        var ranges = [ClosedRange<VendorIdentifier>]()
        var currentRangeStart: VendorIdentifier?
        for vendorId in allVendorIds.sorted() {
            if vendorsToEncode.contains(vendorId) {
                if currentRangeStart == nil {
                    // start a new range
                    currentRangeStart = vendorId
                }
            } else if let rangeStart = currentRangeStart {
                // close the range
                ranges.append(rangeStart...vendorId-1)
                currentRangeStart = nil
            }
        }

        // close any range open at the end
        if let rangeStart = currentRangeStart, let last = vendorsToEncode.last {
            ranges.append(rangeStart...last)
            currentRangeStart = nil
        }
        return ranges
    }

}

private extension String {
    func padLeft(withCharacter character: String = "0", toLength length: Int) -> String {
        let padCount = length - count
        guard padCount > 0 else { return self }
        return String(repeating: character, count: padCount) + self
    }

    func padRight(withCharacter character: String = "0", toLength length: Int) -> String {
        let padCount = length - count
        guard padCount > 0 else { return self }
        return self + String(repeating: character, count: padCount)
    }

    func padRight(withCharacter character: String = "0", toNearestMultipleOf multiple: Int) -> String {
        let (byteCount, bitRemainder) = count.quotientAndRemainder(dividingBy: multiple)
        let totalBytes = byteCount + (bitRemainder > 0 ? 1 : 0)
        return padRight(toLength: totalBytes * multiple)
    }

    func split(by length: Int) -> [String] {
        var startIndex = self.startIndex
        var results = [Substring]()

        while startIndex < self.endIndex {
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            results.append(self[startIndex..<endIndex])
            startIndex = endIndex
        }

        return results.map { String($0) }
    }

    func trimmedWebSafeBase64EncodedString() -> String {
        let data = Data(bytes: split(by: 8).compactMap { UInt8($0, radix: 2) })
        return data.base64EncodedString()
            .trimmingCharacters(in: ["="])
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
    }
}

public extension ConsentString {
    convenience init(created: Date = Date(),
                     updated: Date = Date(),
                     cmpId: Int,
                     cmpVersion: Int,
                     consentScreenId: Int,
                     consentLanguage: String,
                     allowedPurposes: Purposes,
                     vendorListVersion: Int,
                     maxVendorId: VendorIdentifier,
                     defaultConsent: Bool = false,
                     allowedVendorIds: Set<VendorIdentifier>) throws {
        let builder = ConsentStringBuilder()
        try self.init(consentString: try builder.build(created: created,
                                                       updated: updated,
                                                       cmpId: cmpId,
                                                       cmpVersion: cmpVersion,
                                                       consentScreenId: consentScreenId,
                                                       consentLanguage: consentLanguage,
                                                       allowedPurposes: allowedPurposes,
                                                       vendorListVersion: vendorListVersion,
                                                       maxVendorId: maxVendorId,
                                                       defaultConsent: defaultConsent,
                                                       allowedVendorIds: allowedVendorIds))
    }
}
