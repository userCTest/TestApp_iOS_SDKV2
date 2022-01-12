//
//  Usercentrics.swift
//  testApp
//
//  Created by Hugo Silva on 12/01/2022.
//

import Foundation
import Usercentrics
import UsercentricsUI
import UIKit

struct Usercentrics {
    
    private let sdkDefaults = SDKDefaults()
    
    func appInit(){
        /// Initialize Usercentrics with your configuration
        let options = UsercentricsOptions(settingsId: sdkDefaults.settingsId)
        options.loggerLevel = .debug
        UsercentricsCore.configure(options: options)
    }
    
    func resetCMP(){
        UsercentricsCore.reset()
        self.appInit()
    }
    
    func getSettings(customFont: UIFont?, customLogo: UIImage?, showCloseButton: Bool = false) -> UsercentricsUISettings {
        return UsercentricsUISettings(customFont: customFont,
                                      customLogo: customLogo,
                                      showCloseButton: showCloseButton)
    }
    
    func applyConsent(with consents: [UsercentricsServiceConsent]) {
        for service in consents {
            print("\(service.dataProcessor) - TemplateId: \(service.templateId) - Consent Value: \(service.status)")
        }
        print("Applying consent!")
    }
    
    func getTCData(){
        print("Showing TCDCata!")
        UsercentricsCore.isReady { status in

            // CMP Data
            let data = UsercentricsCore.shared.getCMPData()
            //let settings = data.settings
            //let tcfSettings = settings.tcf2

            // TCF Data
            let tcfData = UsercentricsCore.shared.getTCFData()
            let purposes = tcfData.purposes
            //let specialPurposes = tcfData.specialPurposes
            //let features = tcfData.features
            //let specialFeatures = tcfData.specialFeatures
            //let stacks = tcfData.stacks
            let vendors = tcfData.vendors

            // Non-TCF Data - if you have services not included in IAB
            //let services = data.services
            let categories = data.categories
            print("-- CMP DATA --")
            print("Categories: \(categories)")

            // TCString
            print("-- TCSTRING --")
            let tcString = UsercentricsCore.shared.getTCString()
            print("TCString: \(tcString)")

            print("-- PURPOSES --")
            let purposesList = purposes.sorted(by: { tcfVendor1, tcfVendor2 in
                tcfVendor1.id < tcfVendor2.id })
            
            for purpose in purposesList {
                print("\(purpose.name) - Id: \(purpose.id) - Consent: \(String(describing: purpose.consent)) - Legitimate Interest: \(String(describing: purpose.legitimateInterestConsent))")
            }

            print("-- VENDORS WITH CONSENT TRUE--")
            var vendorsList = vendors.filter { tcfVendor in tcfVendor.consent == true }
            vendorsList = vendorsList.sorted(by: { tcfVendor1, tcfVendor2 in
                tcfVendor1.id < tcfVendor2.id })

            for vendor in vendorsList {
                print("\(vendor.name) - Id: \(vendor.id)")
            }


        } onFailure: { error in
            print("Error on initialization: \(error.localizedDescription)")
        }
    }
}