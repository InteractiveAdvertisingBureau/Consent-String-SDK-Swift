//
//  CSVendorConsentString.swift
//  VectauryCMPConsentString
//
//  Created by Pernic on 11/05/2018.
//  Copyright © 2018 Vectaury. All rights reserved.
//

import Foundation

public enum CSVendorEncodingType {
    case notDefined
    case bitfield
    case range
    
    init(_ byte:UInt8) {
        switch byte {
        case 0:
            self = .bitfield
        case 1:
            self = .range
        default:
            self = .notDefined
        }
    }
}

public class CSVendorConsentString {
    
    private static let vendorConsentStringUserDefault = "IABConsent_ConsentString"
    
    public var version:Int64 = 0
    public var created:Date = Date()
    public var lastUpdated:Date = Date()
    public var cmpId:Int64 = 0
    public var cmpVersion:Int64 = 0
    public var consentScreen:Int64 = 0
    public var consentLanguage:String = ""
    public var vendorListVersion:Int64 = 0
    public var purposesAllowed:IndexSet = IndexSet()
    public var maxVendorId:Int64 = 0
    public var encodingType:CSVendorEncodingType = .notDefined
    public var vendorAllowed:IndexSet = IndexSet()
    
    public static var errorDescription : CSError?
    
    @objc public init(version:Int64, created:Date, lastUpdated:Date, cmpId:Int64, cmpVersion:Int64, consentScreen:Int64, consentLanguage:String, vendorListVersion:Int64, purposesAllowed:IndexSet, maxVendorId:Int64, encodingType:UInt8, vendorAllowed:IndexSet) {
        self.version = version
        self.created = created
        self.lastUpdated = lastUpdated
        self.cmpId = cmpId
        self.cmpVersion = cmpVersion
        self.consentScreen = consentScreen
        self.consentLanguage = consentLanguage
        self.vendorListVersion = vendorListVersion
        self.purposesAllowed = purposesAllowed
        self.maxVendorId = maxVendorId
        self.encodingType = CSVendorEncodingType(encodingType)
        self.vendorAllowed = vendorAllowed
    }
    
    @objc public init?(withData data: Data?) {
        if (data == nil) {
            CSVendorConsentString.errorDescription = CSError.dataNotValid
            return;
        }
        do {
            try self.decode(withData: data!)
        } catch let error as CSError {
            CSVendorConsentString.errorDescription = error
            return nil
        } catch {
            CSVendorConsentString.errorDescription = .unknown
            return nil
        }
    }
    
    @objc public convenience init?(withString string: String?) {
        if (string == nil) {
            CSVendorConsentString.errorDescription = CSError.emptyString
            return nil;
        }
        let data = Data(base64Encoded: string!.base64Padded)
        self.init(withData: data)
    }
    
    @objc public convenience init?() {
        let consentString = UserDefaults.standard.string(forKey: "IABConsent_ConsentString")
        self.init(withString: consentString)
    }
    
    @objc public func isPurposeAllowed(purposeId:Int8) -> Bool {
        return purposesAllowed.contains(Int(purposeId))
    }
    
    @objc public func isVendorAllowed(vendorId:Int) -> Bool {
        return vendorAllowed.contains(vendorId)
    }
    
    @objc public func setAllowedVendor (id:Int , allowed:Bool) {
        let mutableset = NSMutableIndexSet(indexSet: self.vendorAllowed)
        if (allowed == false && mutableset.contains(id)) {
            mutableset.remove(id)
        }
        if(allowed == true && !mutableset.contains(id)) {
            mutableset.add(id)
        }
        
        self.vendorAllowed = IndexSet(mutableset)
        if (mutableset.count > 0) {
            self.maxVendorId = Int64(mutableset.lastIndex)
        } else {
            self.maxVendorId = 0
        }
    }
    
    @objc public func addAllowedVendor (id:Int) {
        let mutableset = NSMutableIndexSet(indexSet: self.vendorAllowed)
        mutableset.add(id)
        
        self.vendorAllowed = IndexSet(mutableset)
        self.maxVendorId = Int64(mutableset.lastIndex)
    }
    
    @objc public func setAllowedPurpose (id:Int , allowed:Bool) {
        let mutableset = NSMutableIndexSet(indexSet: self.purposesAllowed)
        if (allowed == false && mutableset.contains(id)) {
            mutableset.remove(id)
        }
        if(allowed == true && !mutableset.contains(id)) {
            mutableset.add(id)
        }
        self.purposesAllowed = IndexSet(mutableset)
    }
    
    @objc public func addAllowedPurpose (id:Int) {
        let mutableset = NSMutableIndexSet(indexSet: self.purposesAllowed)
        mutableset.add(id)
        self.purposesAllowed = IndexSet(mutableset)
    }
    
    @objc public func removeAllowedPurpose (id:Int) {
        let mutableset = NSMutableIndexSet(indexSet: self.purposesAllowed)
        if (mutableset.contains(id)) {
            mutableset.remove(id)
        }
        self.purposesAllowed = IndexSet(mutableset)
    }
    
    @objc public func removeAllowedVendor (id:Int) {
        let mutableset = NSMutableIndexSet(indexSet: self.vendorAllowed)
        if (mutableset.contains(id)) {
            mutableset.remove(id)
        }
        
        self.vendorAllowed = IndexSet(mutableset)
        if (mutableset.count > 0) {
            self.maxVendorId = Int64(mutableset.lastIndex)
        } else {
            self.maxVendorId = 0
        }
    }
    
    
}
