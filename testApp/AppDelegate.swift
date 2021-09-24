//
//  AppDelegate.swift
//  iOSSampleApp
//
//  Created by Pedro Araujo on 13/09/2021.
//

import UIKit
import Usercentrics
import UsercentricsUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let settingsId = "ZDQes7xES"// "egLMgjg9j"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        /// Initialize Usercentrics with your configuration
        let options = UsercentricsOptions(settingsId: settingsId)
        options.loggerLevel = .debug
        UsercentricsCore.configure(options: options)
        return true
    }
}
