////
////  XibInstance.swift
////  miCardAnimation
////
////  Created by Sara_Yang on 2020/11/26.
////  Copyright © 2020 Sara_Yang. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class XibInstantiate: UIView {
//    var xib: UIView!
//    public var previewForInterfaceBuilder: Bool = true
//    public var xibHeirarchy: XibInstantiate.XibPreferHeirarchy = .Default
//
//    public enum XibPreferHeirarchy {
//        case Underneath
//        case Topmost
//        case Default
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib();
//        addXib();
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame);
//        addXib();
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder);
//    }
//    
//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder();
//        if (previewForInterfaceBuilder) {
////            addPreview()
//            addXib()
//        }
//    }
//    
//    func addXib() {
////        if let _xib = BundleUtility.getBundle()?
////            .loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
//        if let _xib = Bundle(for: )
//        
//            
//            self.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            
//            self.xib = _xib
//            switch self.xibHeirarchy {
//                case .Default:
//                    self.addSubview(self.xib)
//                    break
//                case .Topmost:
//                    self.insertSubview(self.xib, at: INTPTR_MAX)
//                    break
//                case .Underneath:
//                    self.insertSubview(self.xib, at: 0)
//                    break
//            }
//
//            self.xib.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//
//            let margins = self.xib.layoutMarginsGuide
//            self.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
//            self.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
//            self.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
//            self.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
//        }
//        self.backgroundColor = .clear
//    }
//    
//    func addPreview() {
//        let name: UILabel = UILabel()
//        name.text = String(describing: type(of: self))
//        let yCons: NSLayoutConstraint = NSLayoutConstraint.init(item: name, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
//        let xCons: NSLayoutConstraint = NSLayoutConstraint.init(item: name, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
//        name.addConstraints([yCons, xCons])
//        self.addSubview(name)
//        self.layoutIfNeeded()
//    }
//}
