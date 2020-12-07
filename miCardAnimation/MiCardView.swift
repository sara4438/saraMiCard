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
//    @IBOutlet weak var lookImg: UIImageView!
    private var context = CIContext(options: nil)
    private var touchePoint: CGPoint?
    private var timer: DispatchSourceTimer? //GCD Timer好棒棒
    private var enterDragingCorner: Corner = .none
    private var distanceX :  Float = 0.0
    private var distanceY :  Float = 0.0
    private var slope : Float = 0.0
    @IBOutlet weak var poker: PokerImageView!
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
//        self.timer =  DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main) as! DispatchSource //创建定时器资源
        
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
//        mirrorImg = UIImage(cgImage:convertUIImageToCGImage(uiImage: self.frontImage!) , scale: 1.0, orientation:.downMirrored )
//        lookImg.image = mirrorImg
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
        var mirrorImg = UIImage(cgImage: self.convertUIImageToCGImage(uiImage: self.frontImage!) , scale: 1.0, orientation: .upMirrored)
        let img3 = pageCurlWithShadowTransition(inputImage: self.backImage!, inputTargetImage: mirrorImg, inputBacksideImage: mirrorImg, inputTimeKey: NSNumber(value: max(distanceX, distanceY) / 250), slope: slope)
        poker.image = img3
    }

    private func pageCurlWithShadowTransition(inputImage: UIImage, inputTargetImage: UIImage, inputBacksideImage: UIImage, inputTimeKey: NSNumber, slope: Float) -> UIImage? {
        guard let filter = CIFilter(name: "CIPageCurlWithShadowTransition") else {
            return nil
        }
        var inputAngle: NSNumber = 0
        var n : Float = 0
        switch self.enterDragingCorner {
            case .leftTop:
                n = -7.833 + Float(sin(getAngle(slope)) * 1.57)
                n = n > -6.28  ? -6.28 : n < -7.833 ? -7.833: n

            case .rightTop:
                n = -1.57 - Float(sin(getAngle(slope)) * 1.57)
                n = n < -3.14  ? -3.14 : n > -1.57 ? -1.57 : n

            case .rightBottom:
                n = -4.71 + Float(sin(getAngle(slope)) * 1.57)
                n = n > -3.14  ? -3.14 : n < -4.71 ? -4.71 : n

            case .leftBottom:
                 n = -4.71 - Float(sin(getAngle(slope)) * 1.57)
                 n = n > -4.71  ? -4.71 : n < -6.28 ? -6.28 : n
            case .top:
                n = -1.57 // or -7.833
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
        let ciImg = CIImage(image: frontImage!)?.oriented(.downMirrored)
        ciImg?.oriented(.downMirrored)
        filter.setValue(ciImg!, forKey: "inputBacksideImage")
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
    
    private func setReleaseCurlImageView() {
        let img3 = pageCurlWithShadowTransition(inputImage: self.backImage!, inputTargetImage: self.frontImage!, inputBacksideImage: self.frontImage!, inputTimeKey: NSNumber(value: max(distanceX, distanceY) / 250), slope: slope)
        poker.image = img3
    }
    
    private func setCurlImageView(inputTimeKeyX: Float, inputTimeKeyY: Float ) {
        switch self.enterDragingCorner {
        case .leftTop:
            distanceY = inputTimeKeyY - Float( self.bounds.minY)
            distanceX = inputTimeKeyX -  Float( self.bounds.minX)
            let y =  Float(self.bounds.midY) - inputTimeKeyY
            let x =  Float(self.bounds.midX) - inputTimeKeyX
            
            slope =  y / x
        case .rightTop:
            distanceY = abs(inputTimeKeyY - Float(self.bounds.minY))
            distanceX = abs(inputTimeKeyX - Float(self.bounds.maxX))
            
            let y = Float(self.bounds.midY) - inputTimeKeyY
            let x = inputTimeKeyX -  Float(self.bounds.midX)
            slope =  y / x
        case .leftBottom:
            distanceY = abs(inputTimeKeyY - Float(self.bounds.maxY))
            distanceX = abs(inputTimeKeyX - Float(self.bounds.minX))
            
            let y =  inputTimeKeyY - Float(self.bounds.midY)
            let x =   abs(Float(self.bounds.midX) - inputTimeKeyX)
            slope =  y / x
        case .rightBottom :
            distanceY = abs(inputTimeKeyY - Float(self.bounds.maxY))
            distanceX = abs(inputTimeKeyX - Float(self.bounds.maxX))
            
            let y =  inputTimeKeyY - Float(self.bounds.midY)
            let x =  inputTimeKeyX - Float(self.bounds.midX)
            slope =  y / x
        case .top:
            distanceY = inputTimeKeyY
        case .right:
            distanceX = abs(Float(self.bounds.maxX) - inputTimeKeyX)
        case .bottom:
            distanceY = abs(Float(self.bounds.maxY) - inputTimeKeyY)
        case .left:
            distanceX = inputTimeKeyX
        default :
            break
        }
        self.updateCurlImageView()
//        let img3 = pageCurlWithShadowTransition(inputImage: img1!, inputTargetImage: img2!, inputBacksideImage: img2!, inputTimeKey: NSNumber(value: Float(30/100)))
        
    }

    
//    private func updateCurlImageView() {
//        var mirrorImg = UIImage(cgImage: self.convertUIImageToCGImage(uiImage: self.frontImage!) , scale: 1.0, orientation: .upMirrored)
//        let img3 = pageCurlWithShadowTransition(inputImage: self.backImage!, inputTargetImage: mirrorImg, inputBacksideImage: mirrorImg, inputTimeKey: NSNumber(value: max(distanceX, distanceY) / 250), slope: slope)
//        poker.image = img3
//    }
//
    
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
                self!.poker.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 180 * 360).concatenating(CGAffineTransform(scaleX: 1, y: 1))
                self!.constraintX.constant = 0
                self!.constraintY.constant = 0
                poker.image =  UIImage(named: "pic_pokerDiamond_04_game_150x210")
                
                self!.layoutIfNeeded()
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
         self.playPokerAnimation(poker: self.poker!, option: .transitionFlipFromBottom) //咪完開牌橫放
        self.enterDragingCorner = .none
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
        let quarterHeight = 1/4 * self.frame.height
        let quarterWidth = 1/4 * self.frame.width
        let midX = self.bounds.midX
        let midY = self.bounds.midY
        if (self.point(inside: point, with: nil)) {
            if (self.point(inside: point, with: nil)) {
                if point.y > midY + quarterHeight &&  point.x < midX - quarterWidth {
                    self.enterDragingCorner = .leftBottom
                    self.setCurlImageView(inputTimeKeyX: Float(point.x), inputTimeKeyY: Float(point.y))
//                    self.updateCurlPoker( point.y , point.x)
                } else if point.y > midY + quarterHeight && point.x > midX + quarterWidth {
                    self.enterDragingCorner = .rightBottom
                    self.setCurlImageView(inputTimeKeyX: Float(point.x), inputTimeKeyY: Float(point.y))
                } else if point.y < midY - quarterHeight && point.x < midX - quarterWidth {
                    self.enterDragingCorner = .leftTop
                    self.setCurlImageView(inputTimeKeyX: Float(point.x), inputTimeKeyY: Float(point.y))
                }else if point.y < midY - quarterHeight && point.x > midX + quarterWidth {
                    self.enterDragingCorner = .rightTop
                    self.setCurlImageView(inputTimeKeyX: Float(point.x), inputTimeKeyY: Float(point.y))
                } else if point.y < midY - quarterHeight && abs(point.x - midX) < quarterWidth {
                    self.enterDragingCorner = .top
                    self.setCurlImageView(inputTimeKeyX: Float(point.x), inputTimeKeyY: Float(point.y))
                }else if point.x > midX + quarterWidth && abs(point.y - midY) < quarterHeight {
                    self.enterDragingCorner = .right
                    self.setCurlImageView(inputTimeKeyX: Float(point.x), inputTimeKeyY: Float(point.y))
                } else if point.y > midY + quarterHeight && abs(point.x - midX) < quarterWidth {
                    self.enterDragingCorner = .bottom
                    self.setCurlImageView(inputTimeKeyX: Float(point.x), inputTimeKeyY: Float(point.y))
                }else if point.x < midX - quarterWidth && abs(point.y - midY) < quarterHeight {
                    self.enterDragingCorner = .left
                    self.setCurlImageView(inputTimeKeyX: Float(point.x), inputTimeKeyY: Float(point.y))
                }
            }
        }
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        if isAnimating {
            return
        }
        let quarterHeight = 0 * self.frame.height
        let quarterWidth = 0 * self.frame.width
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
                    self.setCurlImageView(inputTimeKeyX: Float(point.x ), inputTimeKeyY: Float(point.y ))
                case .rightTop:
                    if point.y > midY + quarterHeight || point.x < midX - quarterWidth {
//                        flipCard()
                        return
                    }
                    self.setCurlImageView(inputTimeKeyX: Float(point.x ), inputTimeKeyY: Float(point.y ))
                case .rightBottom:
                    if point.y < midY - quarterHeight || point.x < midX - quarterWidth {
//                        flipCard()
                        return
                    }
                    self.setCurlImageView(inputTimeKeyX: Float(point.x ), inputTimeKeyY: Float(point.y ))
                case .leftBottom:
                    if point.y < midY - quarterHeight || point.x > midX + quarterWidth {
//                        flipCard()
                        return
                    }
                    self.setCurlImageView(inputTimeKeyX: Float(point.x ), inputTimeKeyY: Float(point.y ))
                case .top:
                    if  point.y > midY + quarterHeight {
//                        flipCard()
                        return
                    }
                    self.setCurlImageView(inputTimeKeyX: Float(point.x ), inputTimeKeyY: Float(point.y ))
                case .right:
                    if  point.x < midX - quarterWidth  {
//                        flipCard()
                        return
                    }
                    self.setCurlImageView(inputTimeKeyX: Float(point.x ), inputTimeKeyY: Float(point.y ))
                case .bottom:
                    if  point.y < midY - quarterHeight  {
//                        flipCard()
                        return
                    }
                    self.setCurlImageView(inputTimeKeyX: Float(point.x ), inputTimeKeyY: Float(point.y ))
                case .left:
                    if  point.x > midX + quarterWidth  {
//                        flipCard()
                        return
                    }
                    self.setCurlImageView(inputTimeKeyX: Float(point.x ), inputTimeKeyY: Float(point.y ))
                default:
                    break
                }
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
                    self.flipBackAnimation()
                case .rightTop:
                    if point.y > self.bounds.midY || point.x < self.bounds.midX {
                        flipCard()
                        return
                    }
                    self.flipBackAnimation()
                case .rightBottom:
                    if point.y < self.bounds.midY || point.x < self.bounds.midX {
                        flipCard()
                        return
                    }
                     self.flipBackAnimation()
                case .leftBottom:
                    if point.y < self.bounds.midY || point.x > self.bounds.midX {
                        flipCard()
                        return
                    }
                    self.flipBackAnimation()
                case .top:
                    if  point.y > self.bounds.midY  {
                        flipCard()
                        return
                    }
                    self.flipBackAnimation()
                case .right:
                    if  point.x < self.bounds.midX  {
                        flipCard()
                        return
                    }
                    self.flipBackAnimation()
                case .bottom:
                    if  point.y < self.bounds.midY  {
                        flipCard()
                        return
                    }
                    self.flipBackAnimation()
                case .left:
                    if  point.x > self.bounds.midX  {
                        flipCard()
                        return
                    }
                    self.flipBackAnimation()
                default:
                    break
                }
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
