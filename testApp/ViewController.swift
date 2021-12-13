//
//  ViewController.swift
//  Test App
//
//  Created by Rui Reis on 05/03/2021.
//

import UIKit
import UsercentricsUI
import Usercentrics

class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnGo: UIButton!
    
    // CMP vars
    let imageName = "usercentrics.jpg"
    
    // UIViewController
    private var predefinedUI: UIViewController?

    // Main View
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnResetAction(_ sender: Any) {
        //UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        UsercentricsCore.reset()
        print("Tapped reset button")
        appInit()        
    }
    
    @IBAction func btnGoAction(_ sender: UIButton) {
        showCMP()
        print("Showing CMP")
    }
    
    func showCMP(){
        // egLMgjg9j
        
        UsercentricsCore.isReady { status in
            self.presentUsercentricsUI(showCloseButton: true)
            print("CMP shown")
        } onFailure: { error in
            print("Error on init: \(error.localizedDescription)")
        }
        
    }
    
    private func presentUsercentricsUI(showCloseButton: Bool) {
        let settings = UsercentricsUISettings(customFont: nil,
                                              customLogo: nil,
                                              showCloseButton: showCloseButton)

        /// Get the UsercentricsUI and display it
        predefinedUI = UsercentricsUserInterface.getPredefinedUI(settings: settings) { [weak self] response in
            guard let self = self else { return }
            /// Process consents
            print("getPredefineUI callback")
            self.applyConsent(with: response.consents)
            self.getTCData()
            self.dismiss(animated: true, completion: nil)
        }

        guard let ui = self.predefinedUI else { return }
        ui.modalPresentationStyle = .overFullScreen
        self.present(ui, animated: true, completion: nil)
    }
    
    private func applyConsent(with consents: [UsercentricsServiceConsent]) {
        for service in consents {
            print("\(service.dataProcessor) - TemplateId: \(service.templateId) - Consent Value: \(service.status)")
        }
        print("Applying consent!")
    }
    
    private func getTCData(){
        //TODO
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

