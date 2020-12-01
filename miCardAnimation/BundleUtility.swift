//
//  BundleUtility.swift
//  miCardAnimation
//
//  Created by Sara_Yang on 2020/11/26.
//  Copyright © 2020 Sara_Yang. All rights reserved.
//

import Foundation

public class BundleUtility {
    
    // ***** For TA use ⬇️
    public static var isPod: Bool = true
    // ***** For TA use ⬆️
    
    private static let bundleName: String = "XBBLiveResource"
    
    public static func getBundle() -> Bundle? {
        let podBundle = Bundle(for: BundleUtility.self)
        
        if (!isPod) {
            // 在IBDesignable下不能使用Bundle.main
            return podBundle
        }
        
        if let bundleURL = podBundle.url(forResource: "XBBLiveResource", withExtension: "bundle") {
                
            if let bundle = Bundle(url: bundleURL) {
                return bundle
             }else {
                assertionFailure("Could not load the bundle")
             }
        }else {
                    
           assertionFailure("Could not create a path to the bundle")
                    
        }
        return nil
    }
}
