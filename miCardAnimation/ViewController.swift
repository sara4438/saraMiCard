//
//  ViewController.swift
//  miCardAnimation
//
//  Created by Sara_Yang on 2020/11/26.
//  Copyright © 2020 Sara_Yang. All rights reserved.
//

import UIKit
import FirebaseAuth


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Auth.auth().createUser(withEmail: "sara54438@hotmail.com", password: "123456") { (result, error) in
                    
             guard let user = result?.user, error == nil else {
                 print(error?.localizedDescription)
                 return
             }
             print(user.email)
        }
        
    }
    

}

