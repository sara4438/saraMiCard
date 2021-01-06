//
//  BViewController.swift
//  miCardAnimation
//
//  Created by Sara_Yang on 2020/12/30.
//  Copyright © 2020 Sara_Yang. All rights reserved.
//
import UIKit
import FirebaseAuth
import FBSDKLoginKit

class BViewController : UIViewController{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var hiLabel: UILabel!
    override func viewDidLoad() {
       super.viewDidLoad()
        if let currentUser = Auth.auth().currentUser {
            self.nameLabel.text = currentUser.displayName
            self.emailLabel.text = currentUser.email
        }
    }
    
    
    
    @IBAction func logout(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            let alertController = UIAlertController(title: "Message", message: "Log out successfully" , preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "好的", style: .cancel, handler: { _ in
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "firstPage") {
                    UIApplication.shared.keyWindow?.rootViewController = viewController
                    self.dismiss(animated: true, completion: nil)
                }
               })
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
           
            
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
}
//  let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
//self.hiLabel.isHidden = true
//self.nameLabel.text = "Please login."
//try firebaseAuth.signOut()
//})
