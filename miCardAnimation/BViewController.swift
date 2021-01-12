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
import RxSwift

class BViewController : UIViewController{
    @IBOutlet weak var toThrottle: UIButton!
    @IBOutlet weak var toQueue: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
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


    //  let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
    //self.hiLabel.isHidden = true
    //self.nameLabel.text = "Please login."
    //try firebaseAuth.signOut()
    //})


    @IBAction func toHorizontal(_ sender: Any) {
        UIState.instance.isVertical.onNext(false)
    }
    @IBAction func toVertical(_ sender: Any) {
        UIState.instance.isVertical.onNext(true)
    }
    @IBAction func reset(_ sender: Any) {
        UIState.instance.reset.onNext(true)
    }
   
    @IBAction func changeDelayState(_ sender: UIButton) {
        if sender == self.toThrottle {
            print("bbb")
            UIState.instance.delayAnimateState.onNext(.throttle)
        } else if sender == self.toQueue {
            print("aaa")
            UIState.instance.delayAnimateState.onNext(.queue)
        } else {
            print("button wrong")
            return
        }
    }
    
    
    
}
