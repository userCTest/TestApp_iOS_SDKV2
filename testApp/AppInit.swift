//
//  AppInit.swift
//  testApp
//
//  Created by Rui Reis on 13/12/2021.
//

import Foundation
import Usercentrics
import UsercentricsUI

let settingsId = "MZaDnW2Ca"//"IhZmAN2p1" //"0zC-fSc9n" // "kpzqDixIF"// "ZDQes7xES", "egLMgjg9j", Gzv1HTSIc

func appInit(){

    /// Initialize Usercentrics with your configuration
    let options = UsercentricsOptions(settingsId: settingsId)
    options.loggerLevel = .debug
    UsercentricsCore.configure(options: options)
}
