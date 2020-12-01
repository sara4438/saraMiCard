//
//  UIImageExtention.swift
//  miCardAnimation
//
//  Created by Sara_Yang on 2020/11/26.
//  Copyright © 2020 Sara_Yang. All rights reserved.
//
import UIKit

//extension UIImage {
    /// Creates a circular outline image. 做一個圓形外框的圖
//    class func outlinedEllipse(size: CGSize, color: UIColor, lineWidth: CGFloat = 1.0) -> UIImage? {
//
//        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
//        guard let context = UIGraphicsGetCurrentContext() else {
//            return nil
//        }
//
//        context.setStrokeColor(color.cgColor)
//        context.setLineWidth(lineWidth)
//
//        let rect = CGRect(origin: .zero, size: size).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
//        context.addEllipse(in: rect)
//        context.strokePath()
//
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
//    }
//
//    static func imageWithURL(url: String) -> UIImage? {
//          do {
//              guard let _url: URL = URL.init(string: url) else { return nil }
//              let _data: Data = try Data.init(contentsOf: _url)
//              guard let _image = UIImage.init(data: _data) else { return nil }
//              return _image
//          } catch {
//              return nil
//          }
//      }
//
//    static func loadImage(named: String) -> UIImage? {
//        return UIImage(named: named, in: BundleUtility.getBundle(), compatibleWith: nil)
//    }
//}
