//
//  AppDelegate.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 16/10/21.
//

import UIKit
import Firebase
import ZVProgressHUD
import Toast_Swift
import AppLovinSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        let settings = ALSdkSettings()
        settings.consentFlowSettings.isEnabled = true
        settings.consentFlowSettings.privacyPolicyURL = URL(string: PRIVACY_URL)
        
        let sdk = ALSdk.shared(with: settings)!
        // Please make sure to set the mediation provider value to "max" to ensure proper functionality
        sdk.mediationProvider = "max"
        sdk.userIdentifier = "USER_ID"
        sdk.initializeSdk { (configuration: ALSdkConfiguration) in
            print("SDK initialised")
        }
        
        var style = ToastStyle()
        style.messageFont = .systemFont(ofSize: 10.0)
        style.messageNumberOfLines = 1
        ToastManager.shared.style = style
        
        /*Loader config*/
        ZVProgressHUD.shared.maskType = .black
        ZVProgressHUD.shared.displayStyle = .custom((backgroundColor: GREEN, foregroundColor: .white))
        ZVProgressHUD.shared.logoSize = CGSize(width: 35.0, height: 35.0)
        ZVProgressHUD.shared.logo = UIImage(named: "emoji")?.withRenderingMode(.alwaysOriginal)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
