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
