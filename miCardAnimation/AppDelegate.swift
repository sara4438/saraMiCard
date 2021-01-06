//
//  AppDelegate.swift
//  miCardAnimation
//
//  Created by Sara_Yang on 2020/11/26.
//  Copyright © 2020 Sara_Yang. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("ccccc","\(error.localizedDescription)")
            }
            return
        }
        // Perform any operations on signed in user here.
//        let userId = user.userID                  // For client-side use only!
//        let idToken = user.authentication.idToken // Safe to send to the server
//        let fullName = user.profile.name
//        let givenName = user.profile.givenName
//        let familyName = user.profile.familyName
//        let email = user.profile.email
        
    // ...
}

func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
          withError error: Error!) {
    // Perform any operations when the user disconnects from app here.
    // ...
}


func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    FirebaseApp.configure() //建立firebase
    ///for Google Login
    GIDSignIn.sharedInstance()?.clientID = "412741437040-i4n6n6qqhl7gvbdq16fg6un2anifvu7h.apps.googleusercontent.com"
    GIDSignIn.sharedInstance()?.delegate = self
        // If user already sign in, restore sign-in state.
    GIDSignIn.sharedInstance()?.restorePreviousSignIn()
    ///for Facebook Login
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    return true
}


// MARK: UISceneSession Lifecycle

func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    var result = true
    if (url.absoluteString.range(of: "facebook") != nil){
        result = ApplicationDelegate.shared.application(app, open: url, options: options)

    }else if (url.absoluteString.range(of: "google") != nil){
        result = GIDSignIn.sharedInstance().handle(url)
    }
    
    return result
}

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

