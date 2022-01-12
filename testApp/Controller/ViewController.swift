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
    
    // Usercentrics
    let uc = Usercentrics()
    
    // UIViewController
    private var predefinedUI: UIViewController?

    // Main View
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnResetAction(_ sender: Any) {
        print("Reset Button Tapped")
        uc.resetCMP()
    }
    
    @IBAction func btnGoAction(_ sender: UIButton) {
        print("Showing CMP")
        showCMP()
    }
    
    private func showCMP(){
        UsercentricsCore.isReady { status in
            print("CMP shown")
            self.presentUsercentricsUI(showCloseButton: true)
        } onFailure: { error in
            print("Error on init: \(error.localizedDescription)")
        }
    }
    
    private func presentUsercentricsUI(showCloseButton: Bool) {
        let settings = uc.getSettings(customFont: nil, customLogo: nil, showCloseButton: showCloseButton)

        /// Get the UsercentricsUI and display it
        predefinedUI = UsercentricsUserInterface.getPredefinedUI(settings: settings) { [weak self] response in
            guard let self = self else { return }
            /// Process consents
            print("getPredefineUI callback")
            self.uc.applyConsent(with: response.consents)
            self.uc.getTCData()
            self.dismiss(animated: true, completion: nil)
        }

        guard let ui = self.predefinedUI else { return }
        ui.modalPresentationStyle = .overFullScreen
        self.present(ui, animated: true, completion: nil)
    }
        
}

