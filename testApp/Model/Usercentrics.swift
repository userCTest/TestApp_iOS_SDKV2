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
    
    func presentBanner(navigationController: UINavigationController?) {
        // Applies to First and Second Layer, and overwrites Admin Interface Styling Settings
        let bannerSettings = BannerSettings(font: nil, logo: nil)

        // Applies to First Layer, and overwrites General Settings
        let firstLayerSettings = FirstLayerStyleSettings(//logo: <LogoSettings?>,
                                                         //title: <TitleSettings?>,
                                                        //message: <MessageSettings?>,
                                                         //buttons: <[ButtonSettings]?>,
                                                         //backgroundColor: <UIColor?>,
                                                         //cornerRadius: <CGFloat?>,
                                                         //overlayColor: UIColor?
                                                        )
        
        // Create a UsercentricsUserInterface instance
        let ui = UsercentricsBanner(bannerSettings: bannerSettings)

        guard let nav = navigationController else {
            fatalError("Error! Navigation Controller is nil.")
        }
            // Show First Layer and handle result
            ui.showFirstLayer(hostView: nav, layout: UsercentricsLayout.full, settings: firstLayerSettings) { userResponse in
                    // Apply Consent
                    self.applyConsent(with: userResponse.consents)
                    // Get Data
                    self.getTCData()
                    // Track User Interaction with userResponse.userInteraction (Only if and until your tracking service has consent)
                    // Save controllerID in your own database with userResponse.controllerId (Needed for Cross-Device Consent Sharing)
            }
    }
}
