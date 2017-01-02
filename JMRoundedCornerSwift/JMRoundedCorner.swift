//
//  UIImage+RoundedCorner.swift
//  JMRoundedCornerSwift
//
//  Created by jm on 16/4/5.
//  Copyright © 2016年 JM. All rights reserved.
//

import UIKit

let jm_operationQueue = OperationQueue()

public struct JMRadius {
    var topLeftRadius: CGFloat
    var topRightRadius: CGFloat
    var bottomLeftRadius: CGFloat
    var bottomRightRadius: CGFloat
}

public func JMRadiusMake(_ topLeftRadius: CGFloat, _ topRightRadius: CGFloat, _ bottomLeftRadius: CGFloat, _ bottomRightRadius: CGFloat) -> JMRadius {
    
    return JMRadius(topLeftRadius: topLeftRadius, topRightRadius: topRightRadius,bottomLeftRadius: bottomLeftRadius,bottomRightRadius: bottomRightRadius)
}

public extension UIView {

    /**给view设置一个 .ScaleAspectFill 模式的圆角背景图*/
    func radiusWith(_ radius: CGFloat, backgroundImage: UIImage?) {
        radiusWith(radius, borderColor: nil, borderWidth: 0, backgroundColor: nil, backgroundImage: backgroundImage, contentMode: .scaleAspectFill)
    }
    
    /**给view设置一个 contentMode 模式的圆角背景图*/
    func radiusWith(_ radius: CGFloat, backgroundImage: UIImage?, contentMode: UIViewContentMode) {
        radiusWith(radius, borderColor: nil, borderWidth: 0, backgroundColor: nil, backgroundImage: backgroundImage, contentMode: contentMode)
    }
    
    /**给view设置一个 contentMode 模式的圆角背景图,你可能还需要配置边框和背景颜色*/
    func radiusWith(_ radius: CGFloat, borderColor: UIColor?, borderWidth: CGFloat, backgroundColor: UIColor?, backgroundImage: UIImage?, contentMode: UIViewContentMode) {
        jm_setRadiusWith(JMRadiusMake(radius, radius, radius, radius), borderColor: borderColor, borderWidth: borderWidth, backgroundColor: backgroundColor, backgroundImage: backgroundImage, contentMode: contentMode)
    }
    
    /**给view设置一个 .ScaleAspectFill 模式的四个圆角弧度可以不同的背景图*/
    func JMRadiusWith(_ radius: JMRadius, backgroundImage: UIImage?) {
        JMRadiusWith(radius, borderColor: nil, borderWidth: 0, backgroundColor: nil, backgroundImage: backgroundImage, contentMode: .scaleAspectFill)
    }
    
    /**给view设置一个 contentMode 模式的四个圆角弧度可以不同的背景图*/
    func JMRadiusWith(_ radius: JMRadius, backgroundImage: UIImage?, contentMode: UIViewContentMode) {
        JMRadiusWith(radius, borderColor: nil, borderWidth: 0, backgroundColor: nil, backgroundImage: backgroundImage, contentMode: contentMode)
    }
    
    /**给view设置一个 contentMode 模式的四个圆角弧度可以不同的背景图,你可能还需要配置边框和背景颜色*/
    func JMRadiusWith(_ radius: JMRadius, borderColor: UIColor?, borderWidth: CGFloat, backgroundColor: UIColor?, backgroundImage: UIImage?, contentMode: UIViewContentMode) {
        jm_setRadiusWith(radius, borderColor: borderColor, borderWidth: borderWidth, backgroundColor: backgroundColor, backgroundImage: backgroundImage, contentMode: contentMode)
    }
}

extension UIView {
    
    fileprivate struct AssociatedKeys {
        static var jm_operationKey = "jm_operation"
    }
    
    var operation: Operation? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.jm_operationKey) as? Operation
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.jm_operationKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func jm_cancelOperation() -> Void {
        let operation = self.operation
        operation?.cancel()
        self.operation = nil
    }
    
    public func jm_setRadiusWith(_ radius: JMRadius, borderColor: UIColor?, borderWidth: CGFloat, backgroundColor: UIColor?, backgroundImage: UIImage?, contentMode: UIViewContentMode) {
        self.jm_cancelOperation()
        
        self.jm_setRadiusWith(radius, borderColor: borderColor, borderWidth: borderWidth, backgroundColor: backgroundColor, backgroundImage: backgroundImage, contentMode: contentMode, size: CGSize.zero)
    }
    
    public func jm_setRadiusWith(_ radius: JMRadius, borderColor: UIColor?, borderWidth: CGFloat, backgroundColor: UIColor?, backgroundImage: UIImage?, contentMode: UIViewContentMode, size: CGSize) {
        
        var _size = size
        weak var wself = self
        let blockOperation = BlockOperation  {
            if ((wself!.operation?.cancel()) != nil) {
                if(_size.equalTo(CGSize.zero)) {
                    DispatchQueue.main.sync(execute: {
                        _size = wself!.bounds.size
                    })
                }
            }
            _size = CGSize(width: pixel(_size.width), height: pixel(_size.height))
            let image = UIImage.jm_setRadiusWith(_size, radius: radius, borderColor: borderColor, borderWidth: borderWidth, backgroundColor: backgroundColor, backgroundImage: backgroundImage, contentMode: contentMode)
            OperationQueue.main.addOperation {
                wself!.frame = CGRect(x: pixel(wself!.frame.origin.x), y: pixel(wself!.frame.origin.y), width: _size.width, height: _size.height)
                if wself is UIImageView {
                    (wself as! UIImageView).image = image
                } else if wself is UIButton && backgroundImage != nil {
                    (wself as! UIButton).setBackgroundImage(image, for: UIControlState())
                } else if wself is UILabel {
                    wself!.layer.backgroundColor = UIColor.init(patternImage: image).cgColor
                } else {
                    wself!.layer.contents = image.cgImage
                }
            }
        }
        self.operation = blockOperation
        jm_operationQueue.addOperation(blockOperation)
    }
}

private func pixel(_ num: CGFloat) -> CGFloat {
    
    let unit = 1.0 / UIScreen.main.scale
    let remain = CGFloat(fmodf(Float(num), Float(unit)))
    return num - remain + (remain >= unit / 2.0 ? unit: 0)
}

extension UIImage {
    
    static func jm_setRadiusWith(_ size: CGSize, radius: JMRadius, borderColor: UIColor?, borderWidth: CGFloat, backgroundColor: UIColor?, backgroundImage: UIImage?, contentMode: UIViewContentMode) -> UIImage {
        var backgroundColor = backgroundColor
        if var image = backgroundImage {
            image = image.scaleWith(size, backgroundColor: backgroundColor, contentMode: contentMode)
            backgroundColor = UIColor.init(patternImage: image)
        } else if backgroundColor == nil {
            backgroundColor = UIColor.white
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let halfBorderWidth = borderWidth / 2
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(borderWidth)
        context?.setStrokeColor((borderColor?.cgColor)!)
        context?.setFillColor((backgroundColor?.cgColor)!)
        let height = size.height
        let width = size.width
        let radius = transformationJMRadius(radius, size: size, borderWidth: borderWidth)
        var startPointY: CGFloat = 0
        if radius.topRightRadius >= height - borderWidth {
            startPointY = height
        } else if radius.topRightRadius > 0 {
            startPointY = halfBorderWidth + radius.topRightRadius
        }
        
        context?.move(to: CGPoint(x: width - halfBorderWidth, y: startPointY))// 开始坐标右边开始
        CGContextAddArcToPoint(context, width - halfBorderWidth, height - halfBorderWidth, width / 2, height - halfBorderWidth, radius.bottomRightRadius)// 右下角角度
        CGContextAddArcToPoint(context, halfBorderWidth, height - halfBorderWidth, halfBorderWidth, height / 2, radius.bottomLeftRadius)// 左下角角度
        CGContextAddArcToPoint(context, halfBorderWidth, halfBorderWidth, width / 2, halfBorderWidth, radius.topLeftRadius)// 左上角
        CGContextAddArcToPoint(context, width - halfBorderWidth, halfBorderWidth, width - halfBorderWidth, height / 2, radius.topRightRadius)// 右上角
        context?.drawPath(using: .fillStroke) //根据坐标绘制路径
        
        let outImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outImage!
    }
    
    fileprivate func scaleWith(_ size: CGSize, backgroundColor: UIColor?, contentMode: UIViewContentMode) -> UIImage {
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        if let color = backgroundColor {
            let context = UIGraphicsGetCurrentContext()
            context?.setFillColor(color.cgColor)
            context?.addRect(rect)
            context?.drawPath(using: .fillStroke)
        }
        draw(in: convertRect(CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height), contentMode: contentMode))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    
    fileprivate func convertRect(_ rect: CGRect, contentMode: UIViewContentMode) -> CGRect {
        
        var size = self.size
        var rect = rect.standardized
        size.width = size.width < 0 ? -size.width : size.width
        size.height = size.height < 0 ? -size.height : size.height
        let center = CGPoint(x: rect.midX, y: rect.midY)
        switch contentMode {
        case .redraw, .scaleAspectFit, .scaleAspectFill:
            if rect.size.width < 0.01 || rect.size.height < 0.01 || size.width < 0.01 || size.height < 0.01 {
                rect.origin = center
                rect.size = CGSize.zero
            } else {
                var scale: CGFloat
                if contentMode == .scaleAspectFill {
                    if size.width / size.height < rect.size.width / rect.size.height {
                        scale = rect.size.width / size.width
                    } else {
                        scale = rect.size.height / size.height
                    }
                } else {
                    if size.width / size.height < rect.size.width / rect.size.height {
                        scale = rect.size.height / size.height
                    } else {
                        scale = rect.size.width / size.width
                    }
                }
                size.width *= scale
                size.height *= scale
                rect.size = size
                rect.origin = CGPoint(x: center.x - size.width * 0.5, y: center.y - size.height * 0.5)
            }
        case .center:
            rect.size = size
            rect.origin = CGPoint(x: center.x - size.width * 0.5, y: center.y - size.height * 0.5)
        case .top:
            rect.origin.x = center.x - size.width * 0.5
            rect.size = size
        case .bottom:
            rect.origin.x = center.x - size.width * 0.5
            rect.origin.y += rect.size.height - size.height
            rect.size = size
        case .left:
            rect.origin.y = center.y - size.height * 0.5
            rect.size = size
        case .right:
            rect.origin.y = center.y - size.height * 0.5
            rect.origin.x += rect.size.width - size.width
            rect.size = size
        case .topLeft:
            rect.size = size
        case .topRight:
            rect.origin.x += rect.size.width - size.width
            rect.size = size
        case .bottomLeft:
            rect.origin.y += rect.size.height - size.height
            rect.size = size
        case .bottomRight:
            rect.origin.x += rect.size.width - size.width
            rect.origin.y += rect.size.height - size.height
            rect.size = size
        default : break
        }
        return rect
    }
}

//根据半径优先级算出新的JMRadius
private func transformationJMRadius(_ radius: JMRadius, size: CGSize, borderWidth: CGFloat) -> JMRadius{
    
    var radius = radius
    radius.topLeftRadius = minimum(size.width - borderWidth, size.height - borderWidth, radius.topLeftRadius - borderWidth / 2)
    radius.topRightRadius = minimum(size.width - borderWidth - radius.topLeftRadius, size.height - borderWidth, radius.topRightRadius - borderWidth / 2)
    radius.bottomLeftRadius = minimum(size.width - borderWidth, size.height - borderWidth - radius.topLeftRadius, radius.bottomLeftRadius - borderWidth / 2)
    radius.bottomRightRadius = minimum(size.width - borderWidth - radius.bottomLeftRadius, size.height - borderWidth - radius.topRightRadius, radius.bottomRightRadius - borderWidth / 2)
    return radius
}

private func minimum(_ a: CGFloat, _ b: CGFloat, _ c: CGFloat) -> CGFloat {
    
    return max(min(min(a, b), c), 0)
}
