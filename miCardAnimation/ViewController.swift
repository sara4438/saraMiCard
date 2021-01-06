//
//  ViewController.swift
//  miCardAnimation
//
//  Created by Sara_Yang on 2020/11/26.
//  Copyright © 2020 Sara_Yang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class ViewController: UIViewController , GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
                print("The user has not signed in before or they have since signed out.")
            } else {
                print("\(error.localizedDescription)")
            }
            return
        }
        
        guard let auth = user.authentication else { return }
        print("xxxxidToken: ", auth.idToken)
        let credential = GoogleAuthProvider.credential(withIDToken:  auth.idToken, accessToken:  auth.accessToken)
        
        Auth.auth().signIn(with:credential , completion: { (user, error) in
            if let error = error {
                print("Login error: \(error.localizedDescription)")
                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okayAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            self.changeToBVC()
        })
    }
    
    @IBAction func check(_ sender: Any) {
        let user = Auth.auth().currentUser
        if user?.uid == nil {
            print("xxxNOTLogin")
        } else {
            print("xxxLOGIN")
        }
    }
    
    @IBOutlet weak var googleLogIn: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LoginManager().logOut()
        GIDSignIn.sharedInstance().signOut()
        do{
            try Auth.auth().signOut()
        }catch let logOutError {
            print(logOutError)
        }
        ///Google sign in
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
    
         //Automatically sign in the user.
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
      
        //fb按鈕
//        let loginButton = FBLoginButton()
//        loginButton.center = CGPoint(x: view.center.x, y: view.center.y + 3/4 * view.center.y)
//        loginButton.permissions = ["public_profile", "email"]
//        view.addSubview(loginButton)
//                if let token = AccessToken.current, !token.isExpired { // User is logged in, do work such as go to next view controller.
//                     print("xxxx", token)
//                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    if let vc = mainStoryboard.instantiateViewController(withIdentifier: "secondPage") as? BViewController
//                    {
//                        print("xxxxx@@@@!!")
//                        self.present(vc, animated: true, completion: nil)
//                    }
//
//                }
        
//    }
        //註冊帳號
//        Auth.auth().createUser(withEmail: "sara123@hotmail.com", password: "123456") { (result, error) in
//
//            guard let user = result?.user, error == nil else {
//                print(error?.localizedDescription)
//                return
//            }
//            print(user.email)
//        }
        
    }
    
    @IBAction func facebookLogin(sender: UIButton) {
        let fbLoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential, completion: { (user, error) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true, completion: nil)
                    return
                }
                self.changeToBVC()
            })
        }
    }
    
//    @IBAction func googleLogin(_ sender: Any) {
//
//
//        // Perform login by calling Firebase APIs
////        Auth.auth().signIn(with: credential, completion: { (user, error) in
////            if let error = error {
////                print("Login error: \(error.localizedDescription)")
////                let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
////                let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
////                alertController.addAction(okayAction)
////                self.present(alertController, animated: true, completion: nil)
////                return
////            }
////            self.changeToBVC()
////        })
//
//    }
    
    public func changeToBVC() {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "secondPage") {
            UIApplication.shared.keyWindow?.rootViewController = viewController
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    
}

