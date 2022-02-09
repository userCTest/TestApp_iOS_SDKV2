//
//  ViewController.swift
//  Test App
//
//  Created by Rui Reis on 05/03/2021.
//

import UIKit
import Usercentrics

class ViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var btnGo: UIButton!
    
    // Usercentrics
    let uc = Usercentrics()
    
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
            self.uc.presentBannerV1(viewController: self)
            //self.uc.presentBannerV2(navigationController: self.navigationController)
            print("CMP shown")
        } onFailure: { error in
            print("Error on init: \(error.localizedDescription)")
        }
    }
}
