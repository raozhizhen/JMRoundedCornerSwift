//
//  UIImage+RoundedCorner.swift
//  JMRoundedCornerSwift
//
//  Created by jm on 16/4/5.
//  Copyright © 2016年 JM. All rights reserved.
//

import UIKit

//枚举
struct JMRadius {
    var topLeftRadius: CGFloat
    var topRightRadius: CGFloat
    var bottomLeftRadius: CGFloat
    var bottomRightRadius: CGFloat
}

func JMRadiusMake(topLeftRadius: CGFloat, _ topRightRadius: CGFloat, _ bottomLeftRadius: CGFloat, _ bottomRightRadius: CGFloat) -> JMRadius {
    return JMRadius(topLeftRadius: topLeftRadius, topRightRadius: topRightRadius,bottomLeftRadius: bottomLeftRadius,bottomRightRadius: bottomRightRadius)
}

//扩展
extension UIImage {
    //类型方法，同 OC 的类方法
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
    
    //私有方法
    private func scaleWith(size: CGSize, backgroundColor: UIColor?, contentMode: UIViewContentMode) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        if let color = backgroundColor {
            let context = UIGraphicsGetCurrentContext()
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextAddRect(context, rect)
            CGContextDrawPath(context, .FillStroke)
        }
        drawInRect(CGRectMake(0, 0, size.width, size.height))
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

private func transformationJMRadius(radius: JMRadius, size: CGSize, borderWidth: CGFloat) -> JMRadius{
    var radius = radius
    radius.topLeftRadius = minimum(size.width - borderWidth, b: size.height - borderWidth, c: radius.topLeftRadius - borderWidth / 2)
    radius.topRightRadius = minimum(size.width - borderWidth - radius.topLeftRadius, b: size.height - borderWidth, c: radius.topRightRadius - borderWidth / 2)
    radius.bottomLeftRadius = minimum(size.width - borderWidth, b: size.height - borderWidth - radius.topLeftRadius, c: radius.bottomLeftRadius - borderWidth / 2)
    radius.bottomRightRadius = minimum(size.width - borderWidth - radius.bottomLeftRadius, b: size.height - borderWidth - radius.topRightRadius, c: radius.bottomRightRadius - borderWidth / 2)
    return radius
}

private func minimum(a: CGFloat, b: CGFloat, c: CGFloat) -> CGFloat {
    return max(min(min(a, b), c), 0)
}



