//
//  ViewController.swift
//  miCardAnimation
//
//  Created by Sara_Yang on 2020/11/26.
//  Copyright © 2020 Sara_Yang. All rights reserved.
//

import UIKit
import FirebaseAuth
import FacebookLogin


class ViewController: UIViewController {

    // Swift override func viewDidLoad() { super.viewDidLoad()  }
        

    // Swift // // Extend the code sample from 6a.Add Facebook Login to Your Code // Add to your viewDidLoad method:
    override func viewDidLoad() {
        super.viewDidLoad()
        //fb按鈕
        let loginButton = FBLoginButton()
        
        loginButton.center = view.center
        loginButton.permissions = ["public_profile", "email"]
        view.addSubview(loginButton)
        if let token = AccessToken.current, !token.isExpired { // User is logged in, do work such as go to next view controller.
             print("xxxx", token)
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = mainStoryboard.instantiateViewController(withIdentifier: "secondPage") as? BViewController
            {
                print("xxxxx@@@@!!")
                self.present(vc, animated: true, completion: nil)
            }
            
        }
       
        
        //註冊帳號
        Auth.auth().createUser(withEmail: "sara123@hotmail.com", password: "123456") { (result, error) in
                    
             guard let user = result?.user, error == nil else {
                 print(error?.localizedDescription)
                 return
             }
             print(user.email)
        }
        
    }
    
//    @IBAction func login(_ sender: Any) {
//        let manager = LoginManager()
//        manager.logIn { (result) in
//           if case LoginResult.success(granted: _, declined: _, token: _) = result {
//                  print("login ok")
//              } else {
//                  print("login fail")
//              }
//        }
//    }
    
    
    

}

