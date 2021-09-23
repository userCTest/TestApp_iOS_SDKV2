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
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnGo: UIButton!
    
    // CMP vars
    let imageName = "usercentrics.jpg"
    
    // UIViewController
    private var predefinedUI: UIViewController?

    // Main View
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        print("Tapped close button")
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
    
    private func applyConsent(with consents: [UsercentricsServiceConsent]) {
        for service in consents {
            print("\(service.dataProcessor) - TemplateId: \(service.templateId) - Consent Value: \(service.status)")
        }
        print("Applying consent!")
    }
    
    private func getTCData(){
        //TODO
        print("Showing TCDCata!")
        
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
}

