//
//  UIImage+RoundedCorner.swift
//  JMRoundedCornerSwift
//
//  Created by jm on 16/4/5.
//  Copyright © 2016年 JM. All rights reserved.
//

import UIKit

let jm_operationQueue = NSOperationQueue()

public struct JMRadius {
    var topLeftRadius: CGFloat
    var topRightRadius: CGFloat
    var bottomLeftRadius: CGFloat
    var bottomRightRadius: CGFloat
}

public func JMRadiusMake(topLeftRadius: CGFloat, _ topRightRadius: CGFloat, _ bottomLeftRadius: CGFloat, _ bottomRightRadius: CGFloat) -> JMRadius {
    
    return JMRadius(topLeftRadius: topLeftRadius, topRightRadius: topRightRadius,bottomLeftRadius: bottomLeftRadius,bottomRightRadius: bottomRightRadius)
}

public extension UIView {

    /**给view设置一个 .ScaleAspectFill 模式的圆角背景图*/
    func radiusWith(radius: CGFloat, backgroundImage: UIImage?) {
        radiusWith(radius, borderColor: nil, borderWidth: 0, backgroundColor: nil, backgroundImage: backgroundImage, contentMode: .ScaleAspectFill)
    }
    
    /**给view设置一个 contentMode 模式的圆角背景图*/
    func radiusWith(radius: CGFloat, backgroundImage: UIImage?, contentMode: UIViewContentMode) {
        radiusWith(radius, borderColor: nil, borderWidth: 0, backgroundColor: nil, backgroundImage: backgroundImage, contentMode: contentMode)
    }
    
    /**给view设置一个 contentMode 模式的圆角背景图,你可能还需要配置边框和背景颜色*/
    func radiusWith(radius: CGFloat, borderColor: UIColor?, borderWidth: CGFloat, backgroundColor: UIColor?, backgroundImage: UIImage?, contentMode: UIViewContentMode) {
        jm_setRadiusWith(JMRadiusMake(radius, radius, radius, radius), borderColor: borderColor, borderWidth: borderWidth, backgroundColor: backgroundColor, backgroundImage: backgroundImage, contentMode: contentMode)
    }
    
    /**给view设置一个 .ScaleAspectFill 模式的四个圆角弧度可以不同的背景图*/
    func JMRadiusWith(radius: JMRadius, backgroundImage: UIImage?) {
        JMRadiusWith(radius, borderColor: nil, borderWidth: 0, backgroundColor: nil, backgroundImage: backgroundImage, contentMode: .ScaleAspectFill)
    }
    
    /**给view设置一个 contentMode 模式的四个圆角弧度可以不同的背景图*/
    func JMRadiusWith(radius: JMRadius, backgroundImage: UIImage?, contentMode: UIViewContentMode) {
        JMRadiusWith(radius, borderColor: nil, borderWidth: 0, backgroundColor: nil, backgroundImage: backgroundImage, contentMode: contentMode)
    }
    
    /**给view设置一个 contentMode 模式的四个圆角弧度可以不同的背景图,你可能还需要配置边框和背景颜色*/
    func JMRadiusWith(radius: JMRadius, borderColor: UIColor?, borderWidth: CGFloat, backgroundColor: UIColor?, backgroundImage: UIImage?, contentMode: UIViewContentMode) {
        jm_setRadiusWith(radius, borderColor: borderColor, borderWidth: borderWidth, backgroundColor: backgroundColor, backgroundImage: backgroundImage, contentMode: contentMode)
    }
}

extension UIView {
    
    private struct AssociatedKeys {
        static var jm_operationKey = "jm_operation"
    }
    
    var operation: NSOperation? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.jm_operationKey) as? NSOperation
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
    
    public func jm_setRadiusWith(radius: JMRadius, borderColor: UIColor?, borderWidth: CGFloat, backgroundColor: UIColor?, backgroundImage: UIImage?, contentMode: UIViewContentMode) {
        self.jm_cancelOperation()
        
        self.jm_setRadiusWith(radius, borderColor: borderColor, borderWidth: borderWidth, backgroundColor: backgroundColor, backgroundImage: backgroundImage, contentMode: contentMode, size: CGSizeZero)
    }
    
    public func jm_setRadiusWith(radius: JMRadius, borderColor: UIColor?, borderWidth: CGFloat, backgroundColor: UIColor?, backgroundImage: UIImage?, contentMode: UIViewContentMode, size: CGSize) {
        
        var _size = size
        
        let blockOperation = NSBlockOperation  { 
            if ((self.operation?.cancel()) != nil) {
                if(CGSizeEqualToSize(_size, CGSizeZero)) {
                    dispatch_sync(dispatch_get_main_queue(), {
                        _size = self.bounds.size
                    })
                }
            }
            _size = CGSizeMake(pixel(_size.width), pixel(_size.height))
            let image = UIImage.jm_setRadiusWith(_size, radius: radius, borderColor: borderColor, borderWidth: borderWidth, backgroundColor: backgroundColor, backgroundImage: backgroundImage, contentMode: contentMode)
            NSOperationQueue.mainQueue().addOperationWithBlock {
                self.frame = CGRectMake(pixel(self.frame.origin.x), pixel(self.frame.origin.y), _size.width, _size.height)
                if self is UIImageView {
                    (self as! UIImageView).image = image
                } else if self is UIButton && backgroundImage != nil {
                    (self as! UIButton).setBackgroundImage(image, forState: .Normal)
                } else if self is UILabel {
                    self.layer.backgroundColor = UIColor.init(patternImage: image).CGColor
                } else {
                    self.layer.contents = image.CGImage
                }
            }
        }
        self.operation = blockOperation
        jm_operationQueue.addOperation(blockOperation)
    }
}

private func pixel(num: CGFloat) -> CGFloat {
    
    let unit = 1.0 / UIScreen.mainScreen().scale
    let remain = CGFloat(fmodf(Float(num), Float(unit)))
    return num - remain + (remain >= unit / 2.0 ? unit: 0)
}

extension UIImage {
    
    static func jm_setRadiusWith(size: CGSize, radius: JMRadius, borderColor: UIColor?, borderWidth: CGFloat, backgroundColor: UIColor?, backgroundImage: UIImage?, contentMode: UIViewContentMode) -> UIImage {
        var backgroundColor = backgroundColor
        if var image = backgroundImage {
            image = image.scaleWith(size, backgroundColor: backgroundColor, contentMode: contentMode)
            backgroundColor = UIColor.init(patternImage: image)
        } else if backgroundColor == nil {
            backgroundColor = UIColor.whiteColor()
        }
        
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        let halfBorderWidth = borderWidth / 2
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, borderWidth)
        CGContextSetStrokeColorWithColor(context, borderColor?.CGColor)
        CGContextSetFillColorWithColor(context, backgroundColor?.CGColor)
        let height = size.height
        let width = size.width
        let radius = transformationJMRadius(radius, size: size, borderWidth: borderWidth)
        var startPointY: CGFloat = 0
        if radius.topRightRadius >= height - borderWidth {
            startPointY = height
        } else if radius.topRightRadius > 0 {
            startPointY = halfBorderWidth + radius.topRightRadius
        }
        
        CGContextMoveToPoint(context, width - halfBorderWidth, startPointY)// 开始坐标右边开始
        CGContextAddArcToPoint(context, width - halfBorderWidth, height - halfBorderWidth, width / 2, height - halfBorderWidth, radius.bottomRightRadius)// 右下角角度
        CGContextAddArcToPoint(context, halfBorderWidth, height - halfBorderWidth, halfBorderWidth, height / 2, radius.bottomLeftRadius)// 左下角角度
        CGContextAddArcToPoint(context, halfBorderWidth, halfBorderWidth, width / 2, halfBorderWidth, radius.topLeftRadius)// 左上角
        CGContextAddArcToPoint(context, width - halfBorderWidth, halfBorderWidth, width - halfBorderWidth, height / 2, radius.topRightRadius)// 右上角
        CGContextDrawPath(context, .FillStroke) //根据坐标绘制路径
        
        let outImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outImage
    }
    
    private func scaleWith(size: CGSize, backgroundColor: UIColor?, contentMode: UIViewContentMode) -> UIImage {
        
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        if let color = backgroundColor {
            let context = UIGraphicsGetCurrentContext()
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextAddRect(context, rect)
            CGContextDrawPath(context, .FillStroke)
        }
        drawInRect(convertRect(CGRectMake(0.0, 0.0, size.width, size.height), contentMode: contentMode))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
    
    private func convertRect(rect: CGRect, contentMode: UIViewContentMode) -> CGRect {
        
        var size = self.size
        var rect = CGRectStandardize(rect)
        size.width = size.width < 0 ? -size.width : size.width
        size.height = size.height < 0 ? -size.height : size.height
        let center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
        switch contentMode {
        case .Redraw, .ScaleAspectFit, .ScaleAspectFill:
            if rect.size.width < 0.01 || rect.size.height < 0.01 || size.width < 0.01 || size.height < 0.01 {
                rect.origin = center
                rect.size = CGSizeZero
            } else {
                var scale: CGFloat
                if contentMode == .ScaleAspectFill {
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
                rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5)
            }
        case .Center:
            rect.size = size
            rect.origin = CGPointMake(center.x - size.width * 0.5, center.y - size.height * 0.5)
        case .Top:
            rect.origin.x = center.x - size.width * 0.5
            rect.size = size
        case .Bottom:
            rect.origin.x = center.x - size.width * 0.5
            rect.origin.y += rect.size.height - size.height
            rect.size = size
        case .Left:
            rect.origin.y = center.y - size.height * 0.5
            rect.size = size
        case .Right:
            rect.origin.y = center.y - size.height * 0.5
            rect.origin.x += rect.size.width - size.width
            rect.size = size
        case .TopLeft:
            rect.size = size
        case .TopRight:
            rect.origin.x += rect.size.width - size.width
            rect.size = size
        case .BottomLeft:
            rect.origin.y += rect.size.height - size.height
            rect.size = size
        case .BottomRight:
            rect.origin.x += rect.size.width - size.width
            rect.origin.y += rect.size.height - size.height
            rect.size = size
        default : break
        }
        return rect
    }
}

//根据半径优先级算出新的JMRadius
private func transformationJMRadius(radius: JMRadius, size: CGSize, borderWidth: CGFloat) -> JMRadius{
    
    var radius = radius
    radius.topLeftRadius = minimum(size.width - borderWidth, size.height - borderWidth, radius.topLeftRadius - borderWidth / 2)
    radius.topRightRadius = minimum(size.width - borderWidth - radius.topLeftRadius, size.height - borderWidth, radius.topRightRadius - borderWidth / 2)
    radius.bottomLeftRadius = minimum(size.width - borderWidth, size.height - borderWidth - radius.topLeftRadius, radius.bottomLeftRadius - borderWidth / 2)
    radius.bottomRightRadius = minimum(size.width - borderWidth - radius.bottomLeftRadius, size.height - borderWidth - radius.topRightRadius, radius.bottomRightRadius - borderWidth / 2)
    return radius
}

private func minimum(a: CGFloat, _ b: CGFloat, _ c: CGFloat) -> CGFloat {
    
    return max(min(min(a, b), c), 0)
}