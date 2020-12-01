//
//  pokerView.swift
//  miCardAnimation
//
//  Created by Sara_Yang on 2020/11/26.
//  Copyright © 2020 Sara_Yang. All rights reserved.
//


import UIKit
//import RxCocoa

class PokerView: UIView {
    @IBOutlet weak var constraintX: NSLayoutConstraint!
    @IBOutlet weak var constraintY: NSLayoutConstraint!
    private var context = CIContext(options: nil)
    private var touchePoint: CGPoint?
    private var startMiCard: Bool = false
    private var timer: Timer?
    private var enterDragingCorner: Corner = .none
    @IBOutlet weak var b3: PokerImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
//         self.miPokerAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
//        self.miPokerAnimation()
    }
    
    func loadXib(){
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PokerView", bundle: bundle)
        ///透過nib來取得xibView
        let xibView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        addSubview(xibView)
        ///設置xibView的Constraint
        xibView.translatesAutoresizingMaskIntoConstraints = false
        xibView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        xibView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        xibView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        xibView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    private func setPokerImageView(poker: PokerImageView, fileName: String, option: AnimationOptions) {
        
        if (poker.usedImageFileName == fileName) {
            return
        }
        
        let shouldDoAnimation = !poker.hasSuit
        if (shouldDoAnimation) {
            do {
                //                let currentTable = try UIState.instance.currentTable.value()
                //                if (currentTable == self.tableID) {
                //                }
            } catch {
                //                print("poker view currentTable error")
            }
            
            UIView.transition(with: poker, duration: 0.3, options: option, animations: {
                poker.image = UIImage(named: "pic_poker_game_150x210")
            }, completion: nil)
        } else {
            poker.image = UIImage(named: fileName)
        }
        poker.usedImageFileName = fileName
        poker.hasSuit = fileName != "pic_poker_250x350"
    }
    
    // MARK: - 咪牌相關
    
    private func getAngle (_ factor: Float) -> Double {
        let angel = Double(factor) / (Double.pi / 180)
        print("ssssFactor", factor)
        print("ssssAngel", angel)
        return angel
    }

    private func pageCurlWithShadowTransition(inputImage: UIImage, inputTargetImage: UIImage, inputBacksideImage: UIImage, inputTimeKey: NSNumber, inputAngleFactor: Float) -> UIImage? {
        guard let filter = CIFilter(name: "CIPageCurlWithShadowTransition") else {
            return nil
        }
        var inputAngle: NSNumber = 0
        var n : Float = 0
        switch self.enterDragingCorner {
            case .leftTop:
                n = -7.05 + (inputAngleFactor > Float(self.frame.height / self.frame.width) ?  -(0.785 * sqrt(inputAngleFactor) * Float(self.frame.width / self.frame.height )) : (inputAngleFactor < 1) ? (0.785 * 1 / sqrt(inputAngleFactor) * Float(self.frame.width / self.frame.height )) : 0 )
                n = n > -6.28  ? -6.28 : n < -7.833 ? -7.833: n
            print("xxxx", 0.785 * sqrt(inputAngleFactor * Float(self.frame.width / self.frame.height)))
//                n = -6.28 //正左
//                n = -7.833 正上
            case .rightTop:
//                n = -2.35 + (inputAngleFactor > Float(self.frame.height / self.frame.width) ? (0.785 * sqrt(inputAngleFactor) * Float(self.frame.width / self.frame.height )) : (-0.785 * 1 / sqrt(inputAngleFactor) * Float(self.frame.width / self.frame.height )))
                n = -3.14 + Float(sin(getAngle(inputAngleFactor)) * 1.57)
//            print("bbbbb", Float(sin(getAngle(inputAngleFactor)) ))
//                n = n < -3.14  ? -3.14 : n > -1.57 ? -1.57 : n
                
//                n = -1.57 //正上
            case .rightBottom:
                n = -3.93 + (inputAngleFactor > Float(self.frame.height / self.frame.width) ?  -(0.785 * sqrt(inputAngleFactor) * Float(self.frame.width / self.frame.height )) :  (0.785 * 1 / sqrt(inputAngleFactor) * Float(self.frame.width / self.frame.height )))
                n = n > -3.14  ? -3.14 : n < -4.71 ? -4.71 : n
            
//                n = -3.14 // 正右

            case .leftBottom:
//                n = -5.5 + (inputAngleFactor > Float( self.frame.height / self.frame.width) ?  (0.785 * sqrt(inputAngleFactor) * Float(self.frame.width / self.frame.height )) : (-0.785 * 1 / sqrt(inputAngleFactor) * Float(self.frame.width / self.frame.height )))
//                n = n > -4.71  ? -4.71 : n < -6.28 ? -6.28 : n
                 n = -6.28 + Float(sin(getAngle(inputAngleFactor)) * 1.57)
                 print("dddd",  Float(sin(getAngle(inputAngleFactor))))
//                n = -4.71 //正下
            case .top:
                n = -1.57
            case .right:
                n = -3.14
            case .bottom:
                n = -4.71
            case .left:
                n = -6.28
            default:
                    break
            }
        inputAngle = NSNumber(value: n )
        filter.setDefaults()
        filter.setValue(CIImage(image: inputImage), forKey: kCIInputImageKey)
        //            filter.setValue(inputTargetImage, forKey: "inputTargetImage")
        filter.setValue(CIImage(image: inputBacksideImage), forKey: "inputBacksideImage")
        filter.setValue(inputTimeKey, forKey: kCIInputTimeKey)
        filter.setValue(inputAngle, forKey: kCIInputAngleKey)
        filter.setValue(5, forKey: kCIInputRadiusKey)
        filter.setValue(1, forKey: "inputShadowSize")
        filter.setValue(1, forKey: "inputShadowAmount")
        //        filter.setValue(inputShadowExtent, forKey: "inputShadowExtent")
        
        let output = filter.outputImage
        let cgimg = self.context.createCGImage(output!,from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        return processedImage
    }
    
    private func updateCurlPoker(_ touchPointY: CGFloat, _ touchPointX: CGFloat) {
        switch self.enterDragingCorner {
            case .leftTop:
//                print("xxxtouchX", touchPointX , "touchY", touchPointY )
//                print( "1/2width", 0.5 * self.frame.width, "1/2height", 0.5 * self.frame.height)
                let distanceY =  Float( touchPointY - self.bounds.minY)
                let distanceX =  Float( touchPointX - self.bounds.minX)
                if distanceY > Float(0.5 * self.frame.height) || distanceX > Float( 0.5 * self.frame.width) {
                    return
                }
                self.setCurlImageView(poker: self.b3!, inputTimeKeyX: distanceX, inputTimeKeyY: distanceY )
            case .rightTop:
                let distanceY = Float(abs(touchPointY - self.bounds.minY))
                let distanceX = Float(abs(touchPointX - self.bounds.maxX))
                self.setCurlImageView(poker: self.b3!, inputTimeKeyX: distanceX, inputTimeKeyY: distanceY )
            case .rightBottom:
                let distanceY = Float(abs(touchPointY - self.bounds.maxY))
                let distanceX = Float(abs(touchPointX - self.bounds.maxX))
                self.setCurlImageView(poker: self.b3!, inputTimeKeyX: distanceX, inputTimeKeyY: distanceY )
            case .leftBottom:
                let distanceY = Float(abs(touchPointY - self.bounds.maxY))
                let distanceX = Float(abs(touchPointX - self.bounds.minX))
                self.setCurlImageView(poker: self.b3!, inputTimeKeyX: distanceX, inputTimeKeyY: distanceY )
            case .top:
                let distanceY =  Float(abs(touchPointY - self.bounds.minY))
                self.setCurlImageView(poker: self.b3!, inputTimeKeyX: 1, inputTimeKeyY: distanceY )
            case .right:
                let distanceX =  Float(abs(touchPointX - self.bounds.maxX))
                self.setCurlImageView(poker: self.b3!, inputTimeKeyX: distanceX, inputTimeKeyY: 1)
            case .bottom:
                let distanceY =  Float(abs(touchPointY - self.bounds.maxY))
                self.setCurlImageView(poker: self.b3!, inputTimeKeyX: 1, inputTimeKeyY: distanceY)
            case .left:
                let distanceX =  Float(abs(touchPointX - self.bounds.minX))
                self.setCurlImageView(poker: self.b3!, inputTimeKeyX: distanceX, inputTimeKeyY: 1)
            default:
                break
            }
    }

    private func setCurlImageView(poker: PokerImageView, inputTimeKeyX: Float, inputTimeKeyY: Float ) {
        let img1 = UIImage(named: "pic_poker_game_150x210")
        let img2 = UIImage(named: "pic_pokerDiamond_04_game_150x210")
        var factor : Float = 0.0
        switch self.enterDragingCorner {
//        case .leftTop:
//            //            if point.y > midY + quarterHeight || point.x > midX + quarterWidth {
//            //                //                        flipCard()
//            //                return
//            //            }
//        //        //                    self.updateCurlPoker(point.y, point.x )
        case .rightTop:
            let y = inputTimeKeyY - Float(1/2 * self.bounds.maxY)
            let x = inputTimeKeyX -  Float(1/2 * self.bounds.maxX)
            factor =  y / x
            print("aaaaa", factor)
        default :
            break
        }
//        let factorX = CGFloat(truncating: inputTimeKeyX) / self.frame.width //y座標
//        let factorY = CGFloat(truncating: inputTimeKeyY) / self.frame.height //x座標
//        let factor : Float = inputTimeKeyY / inputTimeKeyX
            
        let img3 = pageCurlWithShadowTransition(inputImage: img1!, inputTargetImage: img2!, inputBacksideImage: img2!, inputTimeKey: NSNumber(value: max(inputTimeKeyX, inputTimeKeyY) / 250), inputAngleFactor: factor)
//        let img3 = pageCurlWithShadowTransition(inputImage: img1!, inputTargetImage: img2!, inputBacksideImage: img2!, inputTimeKey: NSNumber(value: Float(30/100)))
        poker.image = img3
    }
    
    private func playPokerAnimation(poker: PokerImageView, option: AnimationOptions) {
        //        do {
        ////            let currentTable = try UIState.instance.currentTable.value()
////            if (currentTable == self.tableID) {
////                AudioManager.instance.playSound(soundCase: .PokerDealing)
////            }
//        } catch {
//            print("poker view currentTable error")
//        }
        poker.transform = CGAffineTransform(scaleX: 1, y: 1)
        UIView.transition(with: poker, duration: 0.3, options: option, animations: {
            poker.image = UIImage(named: "pic_pokerDiamond_04_game_150x210")
        }, completion: { [weak self] finished in
            if (!finished) {
                return
            }
            UIView.animate(withDuration: 0.2, animations: {
                self!.b3.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 180 * 360).concatenating(CGAffineTransform(scaleX: 1, y: 1))
                self!.constraintX.constant = 0
                self!.constraintY.constant = 0
                poker.image =  UIImage(named: "pic_pokerDiamond_04_game_150x210")
                
                self!.layoutIfNeeded()
            })
        })
    }
    
    private func miPokerAnimation() { //trigger
        self.b3.image = UIImage(named: "pic_poker_game_150x210")
        self.constraintX.constant = 0
        self.constraintY.constant = 0
        self.layoutIfNeeded()
//        self.b3.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 180 * 360).concatenating(CGAffineTransform(scaleX: 1, y: -1))
        UIView.animate(withDuration: 0.6, animations: {
            let offsetX = self.b3.center.x - self.frame.width / 2
            //            let width = self.bankerWin.frame.width
            //            print(self.b3.frame.origin.x)
            self.b3.transform = CGAffineTransform(scaleX: 2, y: -2)
            self.constraintX.constant -= offsetX
//            self.constraintY.constant -= self.frame.height * 2
            
            self.layoutIfNeeded()
        }, completion: { [weak self] finished in
            if (!finished) {
                return
            }
//            self!.setTimer()
        })
    }
//
//    private func setTimer() {
//        self.b3.tag = 1
//        self.timer = Timer(timeInterval: 0.1, target: self, selector: #selector(updateCurlPoker), userInfo: nil, repeats: true)
//        RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
//    }
//
    private func stopMiCard() {
        b3.image = UIImage(named: "pic_poker_game_150x210")
    }
    
    private func flipCard() {
         self.playPokerAnimation(poker: self.b3!, option: .transitionFlipFromBottom) //咪完開牌橫放
        self.enterDragingCorner = .none
    }
}

extension PokerView {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        let quarterHeight = 1/4 * self.frame.height
        let quarterWidth = 1/4 * self.frame.width
        let midX = self.bounds.midX
        let midY = self.bounds.midY
        if (self.point(inside: point, with: nil)) {
            if (self.point(inside: point, with: nil)) {
                if point.y > midY + quarterHeight &&  point.x < midX - quarterWidth {
                    self.enterDragingCorner = .leftBottom
                    self.updateCurlPoker( point.y , point.x)
                } else if point.y > midY + quarterHeight && point.x > midX + quarterWidth {
                    self.enterDragingCorner = .rightBottom
                    self.updateCurlPoker( point.y, point.x )
                } else if point.y < midY - quarterHeight && point.x < midX - quarterWidth {
                    self.enterDragingCorner = .leftTop
                    self.updateCurlPoker( point.y , point.x)
                }else if point.y < midY - quarterHeight && point.x > midX + quarterWidth {
                    self.enterDragingCorner = .rightTop
                    self.updateCurlPoker( point.y, point.x )
                } else if point.y < midY - quarterHeight && abs(point.x - midX) < quarterWidth {
                    self.enterDragingCorner = .top
                    self.updateCurlPoker( point.y, point.x )
                }else if point.x > midX + quarterWidth && abs(point.y - midY) < quarterHeight {
                    self.enterDragingCorner = .right
                    self.updateCurlPoker( point.y, point.x )
                } else if point.y > midY + quarterHeight && abs(point.x - midX) < quarterWidth {
                    self.enterDragingCorner = .bottom
                    self.updateCurlPoker( point.y, point.x )
                }else if point.x < midX - quarterWidth && abs(point.y - midY) < quarterHeight {
                    self.enterDragingCorner = .left
                    self.updateCurlPoker( point.y, point.x )
                }
            }
        }
    }
    
    
    private func test () {
        self.timer = Timer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
    }
    @objc func update() {
        
    }
    
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        let quarterHeight = 1/4 * self.frame.height
        let quarterWidth = 1/4 * self.frame.width
        let midX = self.bounds.midX
        let midY = self.bounds.midY
        if (self.point(inside: point, with: nil)) {
            if self.enterDragingCorner != .none {
                switch self.enterDragingCorner {
                case .leftTop:
                    if point.y > midY + quarterHeight || point.x > midX + quarterWidth {
//                        flipCard()
                        return
                    }
//                    self.updateCurlPoker(point.y, point.x )
                case .rightTop:
                    if point.y > midY + quarterHeight || point.x < midX - quarterWidth {
//                        flipCard()
                        print("ddddx", point.x, "y ", point.y  )
                        return
                    }
                    print("ddddx", point.x, "y ", point.y  )
                    self.updateCurlPoker( point.y , point.x)
                case .rightBottom:
                    if point.y < midY - quarterHeight || point.x < midX - quarterWidth {
//                        flipCard()
                        return
                    }
                    self.updateCurlPoker(point.y, point.x )
                case .leftBottom:
                    if point.y < midY - quarterHeight || point.x > midX + quarterWidth {
//                        flipCard()
                        return
                    }
                    self.updateCurlPoker(point.y , point.x)
                case .top:
                    if  point.y > midY + quarterHeight {
//                        flipCard()
                        return
                    }
                    self.updateCurlPoker(point.y , point.x)
                case .right:
                    if  point.x < midX - quarterWidth  {
//                        flipCard()
                        return
                    }
                    self.updateCurlPoker(point.y , point.x)
                case .bottom:
                    if  point.y < midY - quarterHeight  {
//                        flipCard()
                        return
                    }
                    self.updateCurlPoker(point.y , point.x)
                case .left:
                    if  point.x > midX + quarterWidth  {
//                        flipCard()
                        return
                    }
                    self.updateCurlPoker(point.y , point.x)
                default:
                    break
                }
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        if self.enterDragingCorner != .none {
            if self.enterDragingCorner != .none {
                switch self.enterDragingCorner {
                case .leftTop:
                    if point.y > self.bounds.midY || point.x > self.bounds.midX {
                        flipCard()
                        return
                    }
                   self.stopMiCard()
                case .rightTop:
                    if point.y > self.bounds.midY || point.x < self.bounds.midX {
                        flipCard()
                        return
                    }
                    self.stopMiCard()
                case .rightBottom:
                    if point.y < self.bounds.midY || point.x < self.bounds.midX {
                        flipCard()
                        return
                    }
                     self.stopMiCard()
                case .leftBottom:
                    if point.y < self.bounds.midY || point.x > self.bounds.midX {
                        flipCard()
                        return
                    }
                    self.stopMiCard()
                case .top:
                    if  point.y > self.bounds.midY  {
                        flipCard()
                        return
                    }
                    self.stopMiCard()
                case .right:
                    if  point.x < self.bounds.midX  {
                        flipCard()
                        return
                    }
                    self.stopMiCard()
                case .bottom:
                    if  point.y < self.bounds.midY  {
                        flipCard()
                        return
                    }
                    self.stopMiCard()
                case .left:
                    if  point.x > self.bounds.midX  {
                        flipCard()
                        return
                    }
                    self.stopMiCard()
                default:
                    break
                }
            }
            self.enterDragingCorner = .none
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.stopMiCard()
        self.enterDragingCorner = .none
    }
}


class PokerImageView: UIImageView {
    public var hasSuit: Bool = false
    public var usedImageFileName: String = "pic_poker_game_150x210"
}


public enum Corner {
    case top
    case right
    case bottom
    case left
    case leftTop
    case leftBottom
    case rightTop
    case rightBottom
    case none
}
