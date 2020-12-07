//
//  ViewController.swift
//  miCardAnimation
//
//  Created by Sara_Yang on 2020/11/26.
//  Copyright © 2020 Sara_Yang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    
    private var mirrorImg: UIImage = UIImage()
    private let frontImage = UIImage(named: "pic_pokerDiamond_04_game_150x210")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func convertUIImageToCGImage(uiImage:UIImage) -> CGImage {
            var cgImage = uiImage.cgImage

            if cgImage == nil {
                let ciImage = uiImage.ciImage
                cgImage = self.convertCIImageToCGImage(ciImage: ciImage!)
            }
            return cgImage!
        }
        
        func convertCIImageToCGImage(ciImage:CIImage) -> CGImage{
            let ciContext = CIContext.init()
            let cgImage:CGImage = ciContext.createCGImage(ciImage, from: ciImage.extent)!
            return cgImage
        }


}

