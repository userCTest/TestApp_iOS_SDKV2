//
//  ViewController.swift
//  Test App
//
//  Created by Rui Reis on 05/03/2021.
//

import UIKit

class ViewController: UIViewController {
    
    // Usercentrics
    let uc = Usercentrics()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnShowCMPAction(_ sender: UIButton) {
        let btnAIdentifier = sender.accessibilityIdentifier
        print("Show CMP Button(\(btnAIdentifier ?? "Not Defined")) Clicked ")
        uc.showCMP(self, buttonIdentifier: sender.accessibilityIdentifier)
    }
    
    @IBAction func btnResetAction(_ sender: Any) {
        print("Reset Button Tapped")
        uc.resetCMP()
    }
}
