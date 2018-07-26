//
//  CSPublisherConsentString.swift
//  VectauryCMPConsentString
//
//  Created by Pernic on 16/05/2018.
//  Copyright © 2018 Vectaury. All rights reserved.
//

import Foundation

public class CSPublisherConsentString {
    
    public var version:Int64 = 0
    public var created:Date = Date()
    public var lastUpdated:Date = Date()
    public var cmpId:Int64 = 0
    public var cmpVersion:Int64 = 0
    public var consentScreen:Int64 = 0
    public var consentLanguage:String = ""
    public var vendorListVersion:Int64 = 0
    public var publisherPurposesVersion:Int64 = 0
    public var standardPurposesAllowed:IndexSet = IndexSet()
    public var numberCustomPurposes:Int64 = 0
    public var customPurposesAllowed:IndexSet = IndexSet()
    
    public static var errorDescription : CSError?
    
    @objc public init() {
    }
    
    @objc public init(version:Int64, created:Date, lastUpdated:Date, cmpId:Int64, cmpVersion:Int64, consentScreen:Int64, consentLanguage:String, vendorListVersion:Int64, publisherPurposesVersion:Int64, standardPurposesAllowed:IndexSet, numberCustomPurposes:Int64, customPurposesAllowed:IndexSet) {
        self.version = version
        self.created = created
        self.lastUpdated = lastUpdated
        self.cmpId = cmpId
        self.cmpVersion = cmpVersion
        self.consentScreen = consentScreen
        self.consentLanguage = consentLanguage
        self.vendorListVersion = vendorListVersion
        self.publisherPurposesVersion = publisherPurposesVersion
        self.standardPurposesAllowed = standardPurposesAllowed
        self.numberCustomPurposes = numberCustomPurposes
        self.customPurposesAllowed = customPurposesAllowed
    }
    
    @objc public init?(withData data: Data?) {
        if (data == nil) {
            CSPublisherConsentString.errorDescription = CSError.dataNotValid
            return;
        }
        do {
            try self.decode(withData: data!)
        } catch let error as CSError {
            CSPublisherConsentString.errorDescription = error
            return nil
        } catch {
            CSPublisherConsentString.errorDescription = .unknown
            return nil
        }
    }
    
    @objc public convenience init?(withString string: String?) {
        if (string == nil) {
            CSPublisherConsentString.errorDescription = CSError.emptyString
            return nil;
        }
        let data = Data(base64Encoded: string!.base64Padded)
        self.init(withData: data)
    }
    
    @objc public func isStandardPurposeAllowed(purposeId:Int8) -> Bool {
        return standardPurposesAllowed.contains(Int(purposeId))
    }
    
    @objc public func isCustomPurposeAllowed(purposeId:NSInteger) -> Bool {
        return customPurposesAllowed.contains(Int(purposeId))
    }
    
    @objc public func setStandardAllowedPurpose (id:Int , allowed:Bool) {
        let mutableset = NSMutableIndexSet(indexSet: self.standardPurposesAllowed)
        if (allowed == false && mutableset.contains(id)) {
            mutableset.remove(id)
        }
        if(allowed == true && !mutableset.contains(id)) {
            mutableset.add(id)
        }
        self.standardPurposesAllowed = IndexSet(mutableset)
    }
    
    @objc public func addStandardAllowedPurpose (id:Int) {
        let mutableset = NSMutableIndexSet(indexSet: self.standardPurposesAllowed)
        mutableset.add(id)
        self.standardPurposesAllowed = IndexSet(mutableset)
    }
    
    @objc public func removeStandardAllowedPurpose (id:Int) {
        let mutableset = NSMutableIndexSet(indexSet: self.standardPurposesAllowed)
        if (mutableset.contains(id)) {
            mutableset.remove(id)
        }
        self.standardPurposesAllowed = IndexSet(mutableset)
    }
    
    @objc public func setCustomAllowedPurpose (id:Int , allowed:Bool) {
        let mutableset = NSMutableIndexSet(indexSet: self.customPurposesAllowed)
        if (allowed == false && mutableset.contains(id)) {
            mutableset.remove(id)
        }
        if(allowed == true && !mutableset.contains(id)) {
            mutableset.add(id)
        }
        self.customPurposesAllowed = IndexSet(mutableset)
    }
    
    @objc public func addCustomAllowedPurpose (id:Int) {
        let mutableset = NSMutableIndexSet(indexSet: self.customPurposesAllowed)
        mutableset.add(id)
        self.customPurposesAllowed = IndexSet(mutableset)
    }
    
    @objc public func removeCustomAllowedPurpose (id:Int) {
        let mutableset = NSMutableIndexSet(indexSet: self.customPurposesAllowed)
        if (mutableset.contains(id)) {
            mutableset.remove(id)
        }
        self.customPurposesAllowed = IndexSet(mutableset)
    }
    
}
