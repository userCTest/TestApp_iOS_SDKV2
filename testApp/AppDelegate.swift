import UIKit
import Usercentrics
import UsercentricsUI

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        /// Initialize Usercentrics with your configuration
        appInit()
        return true
    }
}
