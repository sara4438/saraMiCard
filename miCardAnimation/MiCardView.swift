//
//  pokerView.swift
//  miCardAnimation
//
//  Created by Sara_Yang on 2020/11/26.
//  Copyright © 2020 Sara_Yang. All rights reserved.
//


import UIKit
//import RxCocoa

class MiCardView: UIView {
    @IBOutlet weak var constraintX: NSLayoutConstraint!
    @IBOutlet weak var constraintY: NSLayoutConstraint!
    private var state : State = .vertical
    private var context = CIContext(options: nil)
    private var touchePoint: CGPoint?
    private var timer: DispatchSourceTimer? //GCD Timer好棒棒
    private var enterDragingCorner: Corner = .none
    private var distanceX :  Float = 0.0
    private var distanceY :  Float = 0.0
    private var midX : CGFloat = 0.0
    private var midY : CGFloat = 0.0
    private var minX : CGFloat = 0.0
    private var minY : CGFloat = 0.0
    private var maxX : CGFloat = 0.0
    private var maxY : CGFloat = 0.0
    private var bigPokerX: CGFloat = 0.0
    private var bigPokerY: CGFloat = 0.0
    private var quarterHeight: CGFloat = 0.0
    private var quarterWidth: CGFloat = 0.0
    private var slope : Float = 0.0
    @IBOutlet weak var poker: PokerImageView!
    @IBOutlet weak var bigPoker: PokerImageView!
    @IBOutlet weak var finalPoker: PokerImageView!
    private let backImage = UIImage(named: "pic_poker_game_150x210")
    private let frontImage = UIImage(named: "pic_pokerDiamond_04_game_150x210")
    private let testImg = UIImage(named: "pic_pokerDiamond_10_game_150x210")
    private var isAnimating: Bool = false
    private var mirrorImg: UIImage = UIImage()
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    func loadXib(){
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MiCardView", bundle: bundle)
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
    
    override func layoutSubviews() {
        bigPokerX = self.bigPoker.frame.origin.x
        bigPokerY = self.bigPoker.frame.origin.y
        print("aaaalayout", bigPokerX, bigPokerY)
        self.updateCurlImageView()
        self.updateFinalPokerXY()
        self.finalPoker.isHidden = true
    }
    
    public func updateFinalPokerXY() {
        self.midX = self.finalPoker.frame.midX
        self.midY = self.finalPoker.frame.midY
        self.minX = self.finalPoker.frame.minX
        self.minY = self.finalPoker.frame.minY
        self.maxX = self.finalPoker.frame.maxX
        self.maxY = self.finalPoker.frame.maxY
        self.quarterHeight = 1/4 * self.finalPoker.frame.height
        self.quarterWidth = 1/4 * self.finalPoker.frame.width
       
    }
    
    @IBAction func reset(_ sender: Any) {
        self.bigPoker.isHidden = false
        self.finalPoker.isHidden = true
        self.distanceX = 0
        self.distanceY = 0
        self.state = .vertical
        self.bigPoker.transform = CGAffineTransform(rotationAngle:  CGFloat.pi / 180 * 0 )
        self.finalPoker.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 180 * 0)
//        self.finalPoker.frame.origin.y = self.finalPoker.frame. origin.y
        updateCurlImageView()
        updateFinalPokerXY()
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
    
    private func getAngle (_ factor: Float) -> Float {
        let angel = atan(factor)
        return angel
    }
    
    private func updateCurlImageView() {

        let img3 = pageCurlWithShadowTransition(inputImage: self.backImage!, inputTargetImage: mirrorImg, inputBacksideImage: self.frontImage!, inputTimeKey: NSNumber(value: max(distanceX, distanceY) / 250), slope: slope)
        self.bigPoker.image = img3.0
        print("xxxxxX, ", img3.1, "Y ", img3.2)
//        print("xxxxxOriginPokerXY ", self.bigPokerX ,  self.bigPokerY)
        var xFactor : CGFloat = 0.8
        var yFactor : CGFloat = 0.8
        var n : CGFloat = 0
        var m : CGFloat = 0
        if state == .horizontal {
            switch self.enterDragingCorner {
            case .leftBottom:
//                xFactor = 0.1
//                yFactor = 0.1
                m = 10
                n = -10
            case .bottom:
                xFactor = 0
                n = -8
            case .left:
                n = -2
                m = -5
            default:
                break
            }
        } else {
            switch self.enterDragingCorner {
            case .rightBottom:
                xFactor = 0.1
                yFactor = 0.1
                m = 7
                n = -7
            case .right:
                xFactor = 0
                n = -8
            default:
                break
            }
        }
        
               
        self.bigPoker.frame.origin.x = self.bigPokerX + img3.1 * xFactor + n
        self.bigPoker.frame.origin.y = self.bigPokerY - img3.2 * yFactor + m
        print("xxxxxChangeFrame ", self.bigPoker.frame.origin.x , self.bigPoker.frame.origin.y)
//        if img3.1 < 0 && img3.2 < 0 {
//            return
//        } else if img3.1 < 0 && img3.2 > 0 {
//            self.bigPoker.frame.origin.y = -img3.2 * 1
//        } else if img3.1 > 0 && img3.2 < 0 {
//            self.bigPoker.frame.origin.x = -img3.1 * 1
//        } else {
//
//        self.bigPoker.frame.origin.x = -img3.1 * 1
//        self.bigPoker.frame.origin.y = -img3.2 * 1
//        }
    }

    private func pageCurlWithShadowTransition(inputImage: UIImage, inputTargetImage: UIImage, inputBacksideImage: UIImage, inputTimeKey: NSNumber, slope: Float) -> (UIImage?, CGFloat, CGFloat) {
        guard let filter = CIFilter(name: "CIPageCurlWithShadowTransition") else {
            return (nil,0,0)
        }
        
        var inputAngle: NSNumber = 0
        var n : Float = 0
        var bias: Float = 0
        
        if self.state == .horizontal{
            bias = 1.57
        }
        switch self.enterDragingCorner {
            case .leftTop:
                n = -7.833 + Float(sin(getAngle(slope)) * 1.57)
                n = n > -6.28  ? -6.28 : n < -7.833 ? -7.833: n + bias
                
            case .rightTop:
                n = -1.57 - Float(sin(getAngle(slope)) * 1.57)
                n = n < -3.14  ? -3.14 : n > -1.57 ? -1.57 : n + bias
                
            case .rightBottom:
                n = -4.71 + Float(sin(getAngle(slope)) * 1.57)
                n = n > -3.14  ? -3.14 : n < -4.71 ? -4.71 : n + bias
                
            case .leftBottom:
                n = -4.71 - Float(sin(getAngle(slope)) * 1.57)
                n = n > -4.71  ? -4.71 : n < -6.28 ? -6.28 : n + bias
            case .top:
                n = -1.57 + bias // or -7.833
            case .right:
                n = -3.14 + bias
            case .bottom:
                n = -4.71 + bias
            case .left:
                n = -6.28 + bias
            default:
                break
        }
        
        inputAngle = NSNumber(value: n )
        filter.setDefaults()
        filter.setValue(CIImage(image: inputImage), forKey: kCIInputImageKey)
        //            filter.setValue(inputTargetImage, forKey: "inputTargetImage")
        let ciImg = CIImage(image: frontImage!)?.oriented(.downMirrored)
        ciImg?.oriented(.downMirrored)
        filter.setValue(ciImg!, forKey: "inputBacksideImage")
        filter.setValue(inputTimeKey, forKey: kCIInputTimeKey)
        filter.setValue(inputAngle, forKey: kCIInputAngleKey)
        filter.setValue(15, forKey: kCIInputRadiusKey)

        filter.setValue(1, forKey: "inputShadowSize")
        filter.setValue(1, forKey: "inputShadowAmount")
        //        filter.setValue(inputShadowExtent, forKey: "inputShadowExtent")
        
        // 關鍵在這裡
//        filter.accessibilityElementIsFocused()
        let output = filter.outputImage
        var extent = output!.extent

//        extent.origin.y = -4
//        extent.origin.x = -4

        extent.size.height = 218 * 1.2
        extent.size.width = 158 * 1.3
        
        print(extent)
        let cgimg = self.context.createCGImage(output!,from: extent)
    
        let processedImage = UIImage(cgImage: cgimg!)
        return (img: processedImage,x: extent.origin.x, y: extent.origin.y )
    }

    
    private func flipBackAnimation () {
           if self.enterDragingCorner == .none {
               return
           }
           self.timer =  DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main) as! DispatchSource //創建timer
           timer?.schedule(deadline: .now(), repeating: 0.01)
           timer?.setEventHandler(handler: {
               if self.distanceX <= 0 && self.distanceY <= 0  {
                   self.timer!.cancel()
                   self.distanceX = 0
                   self.distanceY = 0
                   self.enterDragingCorner = .none
                   self.isAnimating = false
                   return
               }
               self.isAnimating = true
               self.distanceX -= 12
               self.distanceY -= 12
               DispatchQueue.main.async {
                   self.updateCurlImageView()
               }
           })
           self.timer?.resume()
           
       }
    
    private func setCurlImageView(inputTimeKeyX: CGFloat, inputTimeKeyY: CGFloat ) {
        var touchPointX: Float = 0
        var touchPointY: Float = 0
        var stopCurlingWidth: CGFloat = 1.2 * self.quarterWidth
        var stopCurlingHeight: CGFloat =  1 * self.quarterHeight
        if self.state == .horizontal {
            stopCurlingWidth = -0.3 * self.quarterWidth
        } else {
            stopCurlingHeight = 0
        }
        
        switch self.enterDragingCorner {
//        case .leftTop:
//            if inputTimeKeyX > midX {
//                touchPointX = Float(midX+10)
//            } else {
//                touchPointX = Float(inputTimeKeyX)
//            }
//            if inputTimeKeyY > midY  {
//                touchPointY = Float(midY+10)
//            } else {
//                touchPointY = Float(inputTimeKeyY)
//            }
//
//            distanceY = touchPointY - Float(minY)
//            distanceX = touchPointX -  Float(minX)
//            let y =  Float(maxY) - touchPointY
//            let x =  Float(maxX) - touchPointX
//
//            slope =  y / x
//        case .rightTop:
//            if inputTimeKeyY > midY {
//                touchPointY = Float(midY)
//            } else {
//                touchPointY = Float(inputTimeKeyY)
//            }
//            if inputTimeKeyX < midX {
//                touchPointX = Float(midX)
//            } else {
//                touchPointX = Float(inputTimeKeyX)
//            }
//
//            distanceY = abs(touchPointY - Float(minY))
//            distanceX = abs(touchPointX - Float(maxX))
//
//            let y = Float(maxY) - touchPointY
//            let x = touchPointX - Float(minX)
//            slope =  y / x
        case .leftBottom:
            if inputTimeKeyX > midX + stopCurlingWidth{
                touchPointX = Float( midX + stopCurlingWidth)
            } else if inputTimeKeyX < minX {
                touchPointX = Float(minX)
            } else {
                touchPointX = Float(inputTimeKeyX)
            }
            if inputTimeKeyY < midY - stopCurlingHeight{
                touchPointY = Float(midY - stopCurlingHeight)
            } else if inputTimeKeyY > maxY {
                touchPointY = Float(maxY)
            } else {
                touchPointY = Float(inputTimeKeyY)
            }
            
            distanceY = abs(touchPointY - Float(maxY))
            distanceX = abs(touchPointX - Float(minX))

            let y =  touchPointY - Float(minY)
            let x =   abs(Float(maxX) - touchPointX)
            slope =  y / x
            
        case .rightBottom :
            if inputTimeKeyX < midX - stopCurlingWidth{
                touchPointX = Float(midX - stopCurlingWidth)
            } else if inputTimeKeyX > maxX {
                touchPointX = Float(maxX)
            } else {
                touchPointX = Float(inputTimeKeyX)
            }
            if inputTimeKeyY < midY - stopCurlingHeight{
                touchPointY = Float(midY - stopCurlingHeight)
            } else if inputTimeKeyY > maxY {
                 touchPointY = Float(maxY)
            } else {
                touchPointY = Float(inputTimeKeyY)
            }
            distanceY = abs(touchPointY - Float(maxY))
            distanceX = abs(touchPointX - Float(maxX))

            let y =  touchPointY - Float(minY)
            let x =  touchPointX - Float(minX)
            slope =  y / x
//        case .top:
//            if inputTimeKeyY > midY {
//                touchPointY = Float(midY)
//            } else {
//                touchPointY = Float(inputTimeKeyY)
//            }
//
//            distanceY = touchPointY - Float(minY)
        case .right:
            if inputTimeKeyX < midX - stopCurlingWidth {
                touchPointX = Float(midX - stopCurlingWidth )
            } else if inputTimeKeyX > maxX {
                touchPointX = Float(maxX)
            } else {
                touchPointX = Float(inputTimeKeyX)
            }
            distanceX = abs(Float(maxX) - touchPointX)
        case .bottom:
            if inputTimeKeyY < midY - stopCurlingHeight {
                touchPointY = Float(midY - stopCurlingHeight )
            } else if inputTimeKeyY > maxY {
                touchPointY = Float(maxY)
            }else{
                touchPointY = Float(inputTimeKeyY)
            }
            
            distanceY = abs(Float(maxY) - touchPointY)
        case .left:
            if inputTimeKeyX > midX + stopCurlingWidth {
                touchPointX = Float(midX + stopCurlingWidth )
            } else if inputTimeKeyX < minX {
                touchPointX = Float(minX)
            }else{
                touchPointX = Float(inputTimeKeyX)
            }
            
            distanceX = touchPointX - Float(minX)
        default :
            break
        }
        self.updateCurlImageView()
//        let img3 = pageCurlWithShadowTransition(inputImage: img1!, inputTargetImage: img2!, inputBacksideImage: img2!, inputTimeKey: NSNumber(value: Float(30/100)))
        
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
        poker.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.transition(with: poker, duration: 0.3, options: option, animations: {
            poker.image = UIImage(named: "pic_pokerDiamond_04_game_150x210")
            if self.state == .horizontal {
                poker.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 180 * 90)
            }
            
        }, completion: { [weak self] finished in
            if (!finished) {
                return
            }
            UIView.animate(withDuration: 0.2, animations: {
//                self?.poker.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 180 * 360).concatenating(CGAffineTransform(scaleX: 1, y: 1))
//                self?.constraintX.constant = 0
//                self?.constraintY.constant = 0
                poker.image =  UIImage(named: "pic_pokerDiamond_04_game_150x210")
                poker.isHidden = true
                poker.transform = CGAffineTransform(scaleX: 1.33, y: 1.33)
                self?.finalPoker.isHidden = false
                self?.layoutIfNeeded()
            })
        })
    }
    
    private func miPokerAnimation() { //trigger
        self.poker.image = UIImage(named: "pic_poker_game_150x210")
        self.constraintX.constant = 0
        self.constraintY.constant = 0
        self.layoutIfNeeded()
//        self.b3.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 180 * 360).concatenating(CGAffineTransform(scaleX: 1, y: -1))
        UIView.animate(withDuration: 0.6, animations: {
            let offsetX = self.poker.center.x - self.frame.width / 2
            //            let width = self.bankerWin.frame.width
            //            print(self.b3.frame.origin.x)
            self.poker.transform = CGAffineTransform(scaleX: 2, y: -2)
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
    
    
    private func flipCard() {
        var verticalAnimate : UIView.AnimationOptions?
        var horizontalAnimate: UIView.AnimationOptions?
        switch self.enterDragingCorner {
//            case .leftTop:
//                verticalAnimate = .transitionFlipFromLeft
//            case .rightTop:
//                verticalAnimate = .transitionFlipFromRight
            case .rightBottom:
                verticalAnimate = .transitionFlipFromRight
            case .leftBottom:
                verticalAnimate = .transitionFlipFromLeft
//            case .top:
//                verticalAnimate = .transitionFlipFromBottom
            case .right:
                verticalAnimate = .transitionFlipFromRight
            case .bottom:
                verticalAnimate = .transitionFlipFromBottom
            case .left:
                verticalAnimate = .transitionFlipFromLeft
            default:
                verticalAnimate = .transitionFlipFromLeft
                break
        }
        self.playPokerAnimation(poker: self.bigPoker!, option: verticalAnimate!)
        self.enterDragingCorner = .none
    }
    
    @IBAction func changeToHorizontal(_ sender: Any) {
        if self.state == .vertical {
            self.state = .horizontal
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, animations: {
//                self.poker.frame = CGRect(x: 0, y: 0, width: self.poker.frame.height, height: self.poker.frame.width)
                self.bigPoker.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 180 * 90)
                self.finalPoker.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 180 * 90)
//                self.finalPoker.frame.origin.y = self.finalPoker.frame.origin.y
                
                self.updateFinalPokerXY()
                print("xxxxxToHorizontalFrame ", self.bigPoker.frame.origin.x , self.bigPoker.frame.origin.y)
//                self.bigPokerX = self.bigPoker.frame.origin.x
//                self.bigPokerY = self.bigPoker.frame.origin.y
            }, completion: nil)
        }
    }
    
    @IBAction func changeToVertical(_ sender: Any) {
        if self.state == .horizontal {
            self.state = .vertical
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, animations: {
                self.bigPoker.transform = CGAffineTransform(rotationAngle:  CGFloat.pi / 180 * 0 )
                self.finalPoker.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 180 * 0)
//                self.finalPoker.frame.origin.y = self.finalPoker.frame.origin.y
                
                 self.updateFinalPokerXY()
                print("sssschangeToV", self.minX, self.minY)
            }, completion: nil)
        }
    }
    

    deinit {
        self.timer?.cancel()
    }
}

extension MiCardView {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        if isAnimating {
            return
        }
        if (self.point(inside: point, with: nil)) {
            if (self.point(inside: point, with: nil)) {
                if point.y > midY + quarterHeight && point.y < maxY && point.x <= midX - quarterWidth && point.x >= minX {
                    self.enterDragingCorner = .leftBottom
                    self.setCurlImageView(inputTimeKeyX: point.x, inputTimeKeyY:point.y)
                } else if point.y > midY + quarterHeight && point.y < maxY && point.x > midX + quarterWidth && point.x < maxX {
                    self.enterDragingCorner = .rightBottom
                    self.setCurlImageView(inputTimeKeyX: point.x, inputTimeKeyY:point.y)
                } else if point.y < midY - quarterHeight && point.y > minY && point.x < midX - quarterWidth && point.x > minX {
                    self.enterDragingCorner = .leftTop
                    self.setCurlImageView(inputTimeKeyX: point.x, inputTimeKeyY:point.y)
                }else if point.y < midY - quarterHeight && point.y > minY && point.x > midX + quarterWidth && point.x < maxX {
                    self.enterDragingCorner = .rightTop
                    self.setCurlImageView(inputTimeKeyX: point.x, inputTimeKeyY:point.y)
                } else if point.y < midY - quarterHeight && point.y > minY && abs(point.x - midX) < quarterWidth {
                    self.enterDragingCorner = .top
                    self.setCurlImageView(inputTimeKeyX: point.x, inputTimeKeyY:point.y)
                }else if point.x > midX + quarterWidth && point.x < maxX && abs(point.y - midY) < quarterHeight {
                    self.enterDragingCorner = .right
                    self.setCurlImageView(inputTimeKeyX: point.x, inputTimeKeyY:point.y)
                } else if point.y > midY + quarterHeight && point.y < maxY && abs(point.x - midX) < quarterWidth {
                    self.enterDragingCorner = .bottom
                    self.setCurlImageView(inputTimeKeyX: point.x, inputTimeKeyY:point.y)
                }else if point.x < midX - quarterWidth && point.x > minX && abs(point.y - midY) < quarterHeight {
                    self.enterDragingCorner = .left
                    self.setCurlImageView(inputTimeKeyX: point.x, inputTimeKeyY:point.y)
                }
            }
            print("aaaa", self.enterDragingCorner)
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        if isAnimating {
            return
        }
       
        if (self.point(inside: point, with: nil)) {
            if self.enterDragingCorner != .none {
                    self.setCurlImageView(inputTimeKeyX: point.x, inputTimeKeyY:point.y)
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        if isAnimating {
            return
        }
        if self.enterDragingCorner != .none {
            if self.enterDragingCorner != .none {
                switch self.enterDragingCorner {
                case .leftTop:
                    if point.y > self.bounds.midY || point.x > self.bounds.midX {
                        flipCard()
                        return
                    }
                case .rightTop:
                    if point.y > self.bounds.midY || point.x < self.bounds.midX {
                        flipCard()
                        return
                    }
                case .rightBottom:
                    if point.y < self.bounds.midY || point.x < self.bounds.midX {
                        flipCard()
                        return
                    }
                case .leftBottom:
                    if point.y < self.bounds.midY || point.x > self.bounds.midX {
                        flipCard()
                        return
                    }
                case .top:
                    if  point.y > self.bounds.midY  {
                        flipCard()
                        return
                    }
                case .right:
                    if  point.x < self.bounds.midX  {
                        flipCard()
                        return
                    }
                case .bottom:
                    if  point.y < self.bounds.midY  {
                        flipCard()
                        return
                    }
                case .left:
                    if  point.x > self.bounds.midX  {
                        flipCard()
                        return
                    }
                default:
                    break
                }
                self.flipBackAnimation()
            }
        }
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isAnimating {
            return
        }
        self.flipBackAnimation()
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

public enum  State {
    case horizontal
    case vertical
}
