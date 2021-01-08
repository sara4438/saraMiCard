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
    override func viewDidLoad() {
       super.viewDidLoad()
    }
    
    @IBAction func toHorizontal(_ sender: Any) {
        UIState.instance.isVertical.onNext(false)
    }
    @IBAction func toVertical(_ sender: Any) {
        UIState.instance.isVertical.onNext(true)
    }
    @IBAction func reset(_ sender: Any) {
        UIState.instance.reset.onNext(true)
    }
}
